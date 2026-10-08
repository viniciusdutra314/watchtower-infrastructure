#!/usr/bin/env python
from dataclasses import dataclass,field
from enum import StrEnum
from pathlib import Path
import tomllib
import platform
import argparse
import os
from typing import Self,Literal
import subprocess
VMS_CONFIGS_PATH=Path(__file__).parent / "vms-configs"
VMS_STATE_PATH=Path(__file__).parent.parent / "vms-state"
SYSTEM=platform.system()
if SYSTEM != "Linux":
    raise RuntimeError("WatchtowerCTL requires Linux or WSL")

#there's no documented way to do it, so last try a few
IS_WSL = "WSL_DISTRO_NAME" in os.environ or "microsoft" in platform.uname().release

ACCELERATOR = "whpx" if IS_WSL else "kvm"
QEMU_EXECUTABLE = "qemu-system-x86_64" + (".exe" if IS_WSL else "")

class HostEnum(StrEnum):
    LAPTOP = "laptop"
    WATCHTOWER_MAIN = "watchtower_main"
    FAMILY_PC = "family_pc"

HOST:HostEnum = (
    HostEnum.FAMILY_PC if IS_WSL
    else HostEnum.WATCHTOWER_MAIN
    if os.uname().nodename.lower() == "watchtower-main"
    else HostEnum.LAPTOP
)

AVAILABLE_VMS=list(
         {p.stem for p in VMS_CONFIGS_PATH.glob("*.toml")}
        & {p.stem for p in VMS_STATE_PATH.glob("*.qcow2")}
        )

SSH_PORTS={
    vm:22_222 + index
    for index,vm in enumerate(AVAILABLE_VMS)
}

@dataclass
class Machine:
    name:str
    vcpus:int
    ram_gb:int
    
    @classmethod
    def from_toml(cls, name: str) -> Self:
        with open(VMS_CONFIGS_PATH / f"{name}.toml","rb") as file:
            data = tomllib.load(file)
        config = data[HOST]
        return cls(
            name=name,
            vcpus=config["vcpus"],
            ram_gb=config["ram_gb"],
        )

    def launch(self)->None:
        qemu_launch_cmd=[
            QEMU_EXECUTABLE,
            "-name", f"{self.name},process={self.name}",
            "-machine", "q35",
            "-accel", ACCELERATOR,
            "-smp", str(self.vcpus),
            "-m", f"{self.ram_gb}G",
            "-drive", f"file={VMS_STATE_PATH / f"{self.name}.qcow2"},format=qcow2,if=virtio",
            "-nic", "user,model=virtio-net-pci",
            "-display", "none",
        ] + (["-cpu","host"] if ACCELERATOR == "kvm" else [])
        subprocess.Popen(
            qemu_launch_cmd,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session= True,
        )


def cmd_vm_start(args:argparse.Namespace)->None:
    machines = [
        Machine.from_toml(vm)
        for vm in args.vms
    ]
    for machine in machines:
        machine.launch()

def cmd_vm_shutdown(args:argparse.Namespace)->None:
    print("vm shutdown")


def main()->None:
    parser = argparse.ArgumentParser(
                    prog='watchtowerctl',
                    description='CLI to control the entire Watchtower 🖥️')
    resources = parser.add_subparsers(required=True)

    container_subparser=resources.add_parser("container",help="Manage docker containers lifetime"
    ",snapshots and updates"
    )
    container_cmds=container_subparser.add_subparsers(required=True)
    container_snapshot_cmd=container_cmds.add_parser("snapshot")

    vm_subparser=resources.add_parser("vm",help="QEMU VMs")
    vm_cmds=vm_subparser.add_subparsers(required=True)
    

    vm_start_cmd=vm_cmds.add_parser("start",help="Start one or more VMs")
    vm_start_cmd.add_argument("vms",help="VM name",nargs="+")
    vm_start_cmd.set_defaults(func=cmd_vm_start)
    
    vm_shutdown_cmd=vm_cmds.add_parser("shutdown",help="Shutdown gracefully VMs")
    vm_shutdown_cmd.set_defaults(func=cmd_vm_shutdown)
    
    
    
    args=parser.parse_args()
    args.func(args)


if __name__=="__main__":
    main()
