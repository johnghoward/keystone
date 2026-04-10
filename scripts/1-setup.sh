#!/usr/bin/env bash

# Source Library
source "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/lib.sh"
source "${PROJECT_DIR}/configs/setup.conf"

echo -e "${GREEN}--- System-Level Configuration ---${NC}"

# 1. Network & Mirrors
pacman -S --noconfirm --needed networkmanager dhclient reflector rsync
systemctl enable NetworkManager.service
reflector -a 48 -c $(curl -s ifconfig.co/country-iso) -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

# 2. Performance Optimization (Makeflags)
NC=$(grep -c ^processor /proc/cpuinfo)
TOTAL_MEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[ $TOTAL_MEM -gt 8000000 ]]; then
    sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$NC\"/g" /etc/makepkg.conf
fi

# 3. Locale & Timezone
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=${KEYMAP:-us}" > /etc/vconsole.conf

# 4. Multilib & Parallel Downloads
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

# 5. User Creation (Secure & Professional)
groupadd -f libvirt
useradd -m -G wheel,libvirt -s /bin/bash $USERNAME 
echo "$USERNAME:$PASSWORD" | chpasswd
echo "$NAME_OF_MACHINE" > /etc/hostname

# Copy installer for 2-user.sh execution
cp -R ${PROJECT_DIR} /home/$USERNAME/
chown -R $USERNAME:$USERNAME /home/$USERNAME/$(basename ${PROJECT_DIR})

# Sudo Rights (Minimal/Secure)
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/keystone-installer

# 6. Hardware (Microcode & GPU)
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
    pacman -S --noconfirm intel-ucode
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
    pacman -S --noconfirm amd-ucode
fi

# Modern Intel/AMD/Nvidia Drivers
gpu_type=$(lspci)
if grep -E "Nvidia|GeForce" <<< ${gpu_type}; then
    pacman -S --noconfirm nvidia-dkms nvidia-utils
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
    pacman -S --noconfirm xf86-video-amdgpu mesa
elif grep -E "Integrated Graphics|Intel" <<< ${gpu_type}; then
    pacman -S --noconfirm intel-media-driver mesa
fi

# 7. LUKS mkinitcpio (if needed)
if [[ "${FS}" == "luks" ]]; then
    sed -i 's/HOOKS=(base udev autodetect modconf block/& encrypt/' /etc/mkinitcpio.conf
    mkinitcpio -p linux
fi

echo -e "${GREEN}--- System-Level Configuration Complete ---${NC}"
