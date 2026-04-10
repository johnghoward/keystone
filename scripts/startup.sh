#!/usr/bin/env bash

# Source Library
source "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/lib.sh"

# Clear screen and show logo
clear
logo

# --- User Info ---
USERNAME=$(input_box "User Setup" "Enter your username:")
set_option USERNAME "${USERNAME,,}"

PASSWORD=$(password_box "User Setup" "Enter your password:")
PASSWORD2=$(password_box "User Setup" "Repeat your password:")

if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
    msg_box "Error" "Passwords do not match. Restarting..."
    exec "$0"
fi
set_option PASSWORD "$PASSWORD"

HOSTNAME=$(input_box "Hostname" "Enter machine hostname:")
set_option NAME_OF_MACHINE "$HOSTNAME"

# --- DE Selection ---
DE=$(menu_box "Desktop Environment" "Select your preferred environment:" \
    "gnome" "Modern Workstation" \
    "kde" "Powerful & Customizable" \
    "xfce" "Lightweight Classic" \
    "server" "CLI Only (Server Optimized)" \
    "minimalist" "Barebones Arch")
set_option DESKTOP_ENV "$DE"

# --- Developer Suite ---
DEV_TOOLS=$(checklist_box "Developer Suite" "Select tools for professional 2026 stack:" \
    "XAMPP" "PHP/MariaDB/Apache Environment" ON \
    "R" "Statistical Computing & Graphics" OFF \
    "Ollama" "Local LLM Execution (AI)" ON \
    "SQLite" "Lightweight SQL database" ON \
    "OpenClaw" "Modern Game Development Port" OFF \
    "Gemini" "AI-Integrated CLI Tools" ON)

for tool in $DEV_TOOLS; do
    tool_clean=$(echo $tool | tr -d '"')
    set_option "DEV_${tool_clean^^}" "YES"
done

# --- Filesystem ---
FS=$(menu_box "Filesystem" "Select your partitioning scheme:" \
    "btrfs" "Modern BTRFS with Subvolumes" \
    "ext4" "Standard Linux Filesystem" \
    "luks" "BTRFS with LUKS Encryption")
set_option FS "$FS"

if [[ "$FS" == "luks" ]]; then
    LUKS_PASS=$(password_box "Encryption" "Enter LUKS encryption password:")
    set_option LUKS_PASSWORD "$LUKS_PASS"
fi

# --- Disk Selection ---
DISKS=$(lsblk -n --output TYPE,KNAME,SIZE | awk '$1=="disk"{print "/dev/"$2" ("$3")"}')
DISK_LIST=()
while read -r line; do
    DISK_LIST+=("$line" "")
done <<< "$DISKS"

SELECTED_DISK=$(menu_box "Disk Selection" "SELECT INSTALLATION DISK (ERASES ALL DATA):" "${DISK_LIST[@]}")
# Extract just /dev/sdX or /dev/nvmeX
DISK_PATH=$(echo "$SELECTED_DISK" | awk '{print $1}')
set_option DISK "$DISK_PATH"

# --- Timezone ---
TIMEZONE=$(curl -s https://ipapi.co/timezone || echo "UTC")
if yesno_box "Timezone" "Detected timezone: $TIMEZONE. Is this correct?"; then
    set_option TIMEZONE "$TIMEZONE"
else
    NEW_TZ=$(input_box "Timezone" "Enter timezone (e.g., Europe/London):")
    set_option TIMEZONE "$NEW_TZ"
fi

# --- AUR Helper ---
AUR=$(menu_box "AUR Helper" "Select your preferred helper:" \
    "paru" "Fast Rust-based helper" \
    "yay" "Go-based classic helper" \
    "none" "No AUR helper")
set_option AUR_HELPER "$AUR"

# --- Profile Export (New Feature) ---
if yesno_box "Profile Export" "Would you like to export this configuration as a reusable profile template?"; then
    set_option PROFILE_EXPORT "YES"
fi

msg_box "Ready" "Configuration complete. Press OK to start installation."
