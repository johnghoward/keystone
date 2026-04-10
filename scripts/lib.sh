#!/usr/bin/env bash
PROJECT_NAME="keystone2"
PROJECT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
CONFIG_FILE="${PROJECT_DIR}/configs/setup.conf"
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export RED='\033[0;31m'
export NC='\033[0m'

logo() {
echo -ne "${GREEN}"
echo -ne "
-------------------------------------------------------------------------
  ██╗  ██╗███████╗██╗   ██╗███████╗████████╗ ██████╗ ███╗   ██╗███████╗
 ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║██╔════╝
 █████╔╝ █████╗   ╚████╔╝ ███████╗   ██║   ██║   ██║██╔██╗ ██║█████╗  
 ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║   ██║   ██║   ██║██║╚██╗██║██╔══╝  
 ██║  ██╗███████╗   ██║   ███████║   ██║   ╚██████╔╝██║ ╚████║███████╗
 ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚══════╝
-------------------------------------------------------------------------
              Keystone2: Professional Developer Suite 2026
-------------------------------------------------------------------------
"
echo -ne "${NC}"
}

set_option() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    if grep -Eq "^${1}.*" "$CONFIG_FILE" 2>/dev/null; then
        sed -i -e "/^${1}.*/d" "$CONFIG_FILE"
    fi
    echo "${1}=${2}" >> "$CONFIG_FILE"
}

msg_box() { whiptail --title "$1" --msgbox "$2" 10 60 ; }
input_box() { whiptail --title "$1" --inputbox "$2" 10 60 3>&1 1>&2 2>&3 ; }
password_box() { whiptail --title "$1" --passwordbox "$2" 10 60 3>&1 1>&2 2>&3 ; }
menu_box() {
    local title="$1"
    local text="$2"
    shift 2
    whiptail --title "$title" --menu "$text" 20 70 10 "$@" 3>&1 1>&2 2>&3
}
checklist_box() {
    local title="$1"
    local text="$2"
    shift 2
    whiptail --title "$title" --checklist "$text" 20 70 10 "$@" 3>&1 1>&2 2>&3
}
yesno_box() { whiptail --title "$1" --yesno "$2" 10 60 ; }

run_step() {
    local script="$1"
    local log="$2"
    echo -e "${BLUE}[STEP] Executing $script...${NC}"
    if ! ( bash "$script" ) |& tee "$log"; then
        echo -e "${RED}[ERROR] $script failed. Check $log for details.${NC}"
        exit 1
    fi
}
