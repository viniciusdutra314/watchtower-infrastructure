#!/usr/bin/env python
from dataclasses import dataclass,field
from enum import StrEnum
from pathlib import Path
import tomllib
import platform
import argparse
from typing import Self
import subprocess

class Host(StrEnum):
    LAPTOP = "laptop"
    GREEN_PC = "green-pc"
    RED_PC = "red-pc"

def get_accelerator() -> str:
    match platform.system():
        case "Linux":
            return "kvm"
        case "Windows":
            return "whpx"
        case system:
            raise RuntimeError(f"Unsupported platform: {system}")

@dataclass
class Machine:
    name:str
    vcpus:int
    ram_gb:int
    accelerator: str = field(
        default_factory=get_accelerator,
        init=False,
    )
    
    @classmethod
    def from_toml(cls, name: str, host: Host) -> Self:
        path = Path(__file__).parent / "machines" / f"{name}.toml"
        with path.open("rb") as file:
            data = tomllib.load(file)
        config = data[host.value]

        return cls(
            name=name,
            vcpus=config["vcpus"],
            ram_gb=config["ram_gb"],
        )

def qemu_command(machine: Machine) -> list[str]:
    disk = Path(__file__).parent / "disks" / f"{machine.name}.qcow2"
    command=[
        "qemu-system-x86_64",
        "-name", f"{machine.name},process={machine.name}",
        "-machine", "q35",
        "-cpu", "host",
        "-accel", machine.accelerator,
        "-smp", str(machine.vcpus),
        "-m", f"{machine.ram_gb}G",
        "-drive", f"file={disk},format=qcow2,if=virtio",
        "-nic", "user,model=virtio-net-pci",
        "-display", "none",
    ]
    if machine.accelerator == "kvm":
        command += ["-cpu", "host"]
    return command


def launch(machine: Machine) -> None:
    system = platform.system()
    if system not in ("Linux", "Windows"):
        raise RuntimeError(f"Unsupported platform: {system}")
    subprocess.Popen(
        qemu_command(machine),
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=system == "Linux",
        creationflags=(
            subprocess.DETACHED_PROCESS
            if system == "Windows"
            else 0
        ),
    )


def main()->None:
    parser = argparse.ArgumentParser(
                    prog='watchtowerctl',
                    description='CLI to launch qemu VMs in both Windows/Linux')
    parser.add_argument(
        "host",
        type=Host,
        choices=list(Host)
    )
    parser.add_argument(
        "vms",
        nargs="+",
        metavar="VM"
    )
    args=parser.parse_args()
    machines = [
        Machine.from_toml(vm, args.host)
        for vm in args.vms
    ]
    for machine in machines:
        command=qemu_command(machine)
        print(" ".join(command))
        launch(machine)

if __name__=="__main__":
    main()