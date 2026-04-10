#!/usr/bin/env bash

# Source Library
source "/home/$USER/keystone2/scripts/lib.sh"
source "/home/$USER/keystone2/configs/setup.conf"

echo -e "${GREEN}--- User-Space Configuration ---${NC}"

# 1. ZSH Setup (Professional Shell)
cd ~
git clone --depth=1 "https://github.com/ChrisTitusTech/zsh" ~/zsh_config
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
ln -sf "$HOME/zsh_config/.zshrc" "$HOME/.zshrc"
echo "alias ls='ls --color=auto'" >> ~/.zshrc

# 2. AUR Helper Installation
if [[ ! $AUR_HELPER == none ]]; then
  echo -e "${BLUE}Installing AUR Helper: $AUR_HELPER${NC}"
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  
  # Install professional developer suite tools via AUR
  if [[ $DEV_XAMPP == "YES" ]]; then
    $AUR_HELPER -S --noconfirm --needed xampp
  fi
  if [[ $DEV_OPENCLAW == "YES" ]]; then
    $AUR_HELPER -S --noconfirm --needed openclaw-git
  fi
fi

# 3. Modern Tooling with UV (2026 Developer Standards)
echo -e "${BLUE}Setting up Modern Tooling (uv/uvx)...${NC}"
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env

# Install Gemini CLI via UVX (Isolated & Fast)
if [[ $DEV_GEMINI == "YES" ]]; then
  echo "Setting up Gemini CLI alias..."
  echo "alias gemini='uvx @google/gemini-cli'" >> ~/.zshrc
  echo "alias gemini='uvx @google/gemini-cli'" >> ~/.bashrc
fi

# 4. Standard Repos Developer Tools
echo -e "${BLUE}Installing Standard Repo Tools...${NC}"
S_TOOLS=()
[[ $DEV_R == "YES" ]] && S_TOOLS+=("r")
[[ $DEV_SQLITE == "YES" ]] && S_TOOLS+=("sqlite")
[[ $DEV_OLLAMA == "YES" ]] && S_TOOLS+=("ollama")

if [[ ${#S_TOOLS[@]} -gt 0 ]]; then
  sudo pacman -S --noconfirm --needed "${S_TOOLS[@]}"
  if [[ $DEV_OLLAMA == "YES" ]]; then
    sudo systemctl enable --now ollama.service
  fi
fi

# 5. Profile Export Feature (New)
if [[ $PROFILE_EXPORT == "YES" ]]; then
  echo -e "${GREEN}Exporting Profile Template...${NC}"
  mkdir -p ~/keystone_profiles
  cp /home/$USER/keystone2/configs/setup.conf ~/keystone_profiles/custom_profile.conf
  echo "Profile saved to ~/keystone_profiles/custom_profile.conf"
fi

# 5.5 Setup Keystone Companion (React Dashboard)
echo -e "${BLUE}Setting up Keystone Companion App...${NC}"
cp -R /home/$USER/keystone2/companion-app ~/companion-app
printf "alias companion='cd ~/companion-app && npm run dev'\n" >> ~/.zshrc
echo "To start the dashboard after install, run 'companion' in your terminal." > ~/companion-app/START_HERE.txt

# 6. Apply Wallpaper and Theming (Professional Finish)
if [[ $DESKTOP_ENV == "kde" && $INSTALL_TYPE == "FULL" ]]; then
    pip install --user konsave
    konsave -i /home/$USER/keystone2/configs/kde.knsv
    konsave -a kde
fi

echo -e "${GREEN}--- User-Space Complete ---${NC}"
