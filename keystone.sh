#!/usr/bin/env bash

# Find the name of the folder the scripts are in
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
CONFIGS_DIR="${SCRIPT_DIR}/configs"

# Source the library
source "${SCRIPTS_DIR}/lib.sh"

# Show Logo
logo

# Execute Steps with professional error handling
run_step "${SCRIPTS_DIR}/startup.sh" "startup.log"
source "${CONFIGS_DIR}/setup.conf"

run_step "${SCRIPTS_DIR}/0-preinstall.sh" "0-preinstall.log"
run_step "arch-chroot /mnt /root/keystone2/scripts/1-setup.sh" "1-setup.log"

if [[ ! $DESKTOP_ENV == server && ! $DESKTOP_ENV == minimalist ]]; then
  run_step "arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/keystone2/scripts/2-user.sh" "2-user.log"
fi

run_step "arch-chroot /mnt /root/keystone2/scripts/3-post-setup.sh" "3-post-setup.log"

# Final Cleanup
cp -v *.log /mnt/home/$USERNAME/

echo -ne "
-------------------------------------------------------------------------
                    Keystone2 Installation Complete
-------------------------------------------------------------------------
                Please Eject Install Media and Reboot
"

if command -v fastfetch &> /dev/null; then
    fastfetch
fi
