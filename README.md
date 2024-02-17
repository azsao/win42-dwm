<div align="center">

# win42-dwm

![Status: Active](https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square) ![Arch DWM](https://img.shields.io/badge/Arch-DWM-blue?style=flat-square) ![Owner: azsao](https://img.shields.io/badge/Owner-azsao-yellow?style=flat-square) ![Workstation](https://img.shields.io/badge/Workstation-red?style=flat-square)

</div>

**16/2/2024 THIS REPOSITORY IS UNDER CONSTRUCTION, SOME SCRIPTS MAY BE BROKEN OR CARRY INCONSISTANCYS**

**Warning:** This is specifically designed to run on x64 bit computers.

Here is a standard arch + dwm minimilistic auto-installer.

The sole purpose of this repository is to provide users with a streamlined and efficient method for installing Arch Linux automatically. By leveraging this minimalist auto-arch installer, users can swiftly deploy Arch Linux on their systems with minimal manual intervention. This tool aims to simplify the installation process, reducing the complexity often associated with setting up Arch Linux from scratch. It also included a windows-arch dual boot via grub, hence the name Win42-DWM! 

## Information:  

`/usr/local/bin/dwm`
Your main dwm install is located here, it is not to be confused with:

`~/.suckless`
These are your configuartion files, feel free to tweak them as needed, in this repository, it should have set up a user-friendly information

<details>
  <summary><strong>Pre-Preparation</strong></summary>

Open Disk Management: Press the Windows + R keys to open the Run dialog box and type diskmgmt.msc1. Alternatively, you can right-click on the Start menu icon in the taskbar and select "Disk Management"

Shrink Volume: Right-click on the C: drive and select "Shrink Volume"1. In the following dialog box, you can specify how much space the new partition should have1. Windows will offer to shrink the entire available memory on the hard disk by default2. If you want to assign a smaller amount of memory to the partition, simply adjust the value beside "Enter the amount of space to shrink in MB"1. You can specify the value in megabytes1.

Create the First Partition:
Right-click on the unallocated space created from shrinking the volume and select "New Simple Volume". Follow the wizard, specify the size for this partition in MBs (this will be the size of your first partition), 

Repeat for the Other Two Partitions:
Follow the same process of shrinking the volume and creating new partitions for the remaining unallocated space.

Remember to allocate a sufficent amount of resources! 3 partitions are recomended
- EFI (2000 mb)
- Swap (10000 mb)
- ROOT (Main filesystem, include as much space as you want)


</details>

<details>
  <summary><strong>Requirements</strong></summary>

Hardware Requirements:

- A 64-bit capable processor.
  At least 512 MB of RAM (recommended minimum is 2 GB).
  At least 1 GB of free disk space (recommended minimum is 20 GB for a basic installation, but more is recommended if you plan to install additional software or store data).
  A reliable internet connection (for downloading packages and updates during installation).

Installation Medium:

- An Arch Linux ISO image. You can download the latest ISO from the official Arch Linux website.
  You can either burn the ISO to a CD/DVD or write it to a USB flash drive to use as the installation medium. Tools like Rufus, Etcher, or dd can be used for this purpose.

Bootable Media Creation:

- If using a USB drive, ensure it's bootable. This involves writing the Arch Linux ISO image to the USB drive using a tool like Rufus (on Windows), Etcher (on macOS, Windows, or Linux), or dd (on Linux).



</details>


## Installation

Boot into Arch Linux ISO Environment:

    Insert your Arch Linux installation media (USB drive or bootable ISO).
    Boot your computer from the Arch Linux installation media. This might involve changing your BIOS/UEFI settings to prioritize booting from the USB drive or ISO.

Establish an Internet Connection:

    If your system doesn't automatically connect to the internet, you'll need to establish a connection. Use the following commands:
    # Check available network interfaces
    ip link
    # Activate a network interface (replace "interface_name" with your interface, e.g., "enp0s3" or "wlan0")
    ip link set interface_name up
    # Connect to a Wi-Fi network (replace "SSID" and "password" with your Wi-Fi credentials)
    wifi-menu

Install Git (if not already installed):
    # Update the package repositories:
    pacman -Sy
    # Install Git:
    pacman -S git

Download the Script:

    # Navigate to a directory where you want to download the script. For example, to download it to your home directory:
    cd ~

Clone the repository containing the script using Git:
    git clone https://github.com/azsao/win42-dwm.git

Navigate to the Script Directory:

    # Change directory to the directory where the script is downloaded. If you used the git clone command, this will typically be a subdirectory with the repository's name:
    cd win42-dwm

Make the Script Executable:

    # Make the script executable using the chmod command:
    chmod +x archinstall.sh

Run the Script:

    # Execute the script using ./ followed by the script name. 
     ./<script_name>



If you're looking for an dwm autoricer then I recommend looking at [yankee.dwm](https://github.com/azsao/yankee.dwm) repository


