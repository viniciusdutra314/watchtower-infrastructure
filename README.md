
> *“Watchtower is officially online...”*

<p align="center">
  <img src="assets/watchtower-banner.jpg" alt="Watchtower" width="800">
</p>

**Watchtower Infrastructure** is my portable home-server setup: a small,
cross-platform Python orchestration layer for running virtual machines,
containers and services from a single portable SSD.

The basic idea is simple: plug the SSD into a machine, start the Watchtower,
and the infrastructure comes with it.

🖥️ **QEMU** runs the virtual machines.  
📦 **Docker** provides the containerized services.  
🛰️ **`watchtowerctl`** ties everything together.

The Python tooling handles host-specific configuration and provides a common
control layer across different machines and operating systems — currently
Linux and Windows.

The project is built around keeping **configuration separate from state**.
NixOS configuration, VM and container definitions, metadata and orchestration
code are versioned here, while large virtual disks, persistent container data
and secrets deliberately live outside the Git repository.


