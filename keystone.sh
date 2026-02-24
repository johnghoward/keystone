#!/bin/bash

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
echo -ne "
-------------------------------------------------------------------------
  ██╗  ██╗███████╗██╗   ██╗███████╗████████╗ ██████╗ ███╗   ██╗███████╗
 ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║██╔════╝
 █████╔╝ █████╗   ╚████╔╝ ███████╗   ██║   ██║   ██║██╔██╗ ██║█████╗  
 ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║   ██║   ██║   ██║██║╚██╗██║██╔══╝  
 ██║  ██╗███████╗   ██║   ███████║   ██║   ╚██████╔╝██║ ╚████║███████╗
 ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚══════╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                     Keystone by John G. Howard
                 (Inspired by Chris Titus' ArchTitus)
-------------------------------------------------------------------------
                Scripts are in directory named Keystone
"
    ( bash $SCRIPT_DIR/scripts/startup.sh )|& tee startup.log
      source $CONFIGS_DIR/setup.conf
    ( bash $SCRIPT_DIR/scripts/0-preinstall.sh )|& tee 0-preinstall.log
    ( arch-chroot /mnt $HOME/Keystone/scripts/1-setup.sh )|& tee 1-setup.log
    if [[ ! $DESKTOP_ENV == server && ! $DESKTOP_ENV == minimalist ]]; then
      ( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/Keystone/scripts/2-user.sh )|& tee 2-user.log
    fi
    ( arch-chroot /mnt $HOME/Keystone/scripts/3-post-setup.sh )|& tee 3-post-setup.log
    cp -v *.log /mnt/home/$USERNAME

echo -ne "
-------------------------------------------------------------------------
  ██╗  ██╗███████╗██╗   ██╗███████╗████████╗ ██████╗ ███╗   ██╗███████╗
 ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║██╔════╝
 █████╔╝ █████╗   ╚████╔╝ ███████╗   ██║   ██║   ██║██╔██╗ ██║█████╗  
 ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║   ██║   ██║   ██║██║╚██╗██║██╔══╝  
 ██║  ██╗███████╗   ██║   ███████║   ██║   ╚██████╔╝██║ ╚████║███████╗
 ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚══════╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"

# Use fastfetch for a professional 2026 summary
if command -v fastfetch &> /dev/null; then
    fastfetch
fi
