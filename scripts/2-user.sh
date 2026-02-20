#!/usr/bin/env bash
echo -ne "
-------------------------------------------------------------------------
  ██████╗ ██████╗ ███████╗███╗   ██╗ █████╗ ██████╗  ██████╗██╗  ██╗
 ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗██╔══██╗██╔════╝██║  ██║
 ██║   ██║██████╔╝█████╗  ██╔██╗ ██║███████║██████╔╝██║     ███████║
 ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██╔══██║██╔══██╗██║     ██╔══██║
 ╚██████╔╝██║     ███████╗██║ ╚████║██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: OpenArch
-------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/OpenArch/configs/setup.conf

  cd ~
  mkdir "/home/$USERNAME/.cache"
  touch "/home/$USERNAME/.cache/zshhistory"
  git clone "https://github.com/ChrisTitusTech/zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  ln -sf "$HOME/zsh/.zshrc" "$HOME/.zshrc"

sed -n '/'$INSTALL_TYPE'/q;p' ~/OpenArch/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]
  then
    # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
    continue
  fi
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done


if [[ ! $AUR_HELPER == none ]]; then
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  # sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
  # stop the script and move on, not installing any more packages below that line
  sed -n '/'$INSTALL_TYPE'/q;p' ~/OpenArch/pkg-files/aur-pkgs.txt | while read line
  do
    if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
      # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
      continue
    fi
    echo "INSTALLING: ${line}"
    $AUR_HELPER -S --noconfirm --needed ${line}
  done
fi

export PATH=$PATH:~/.local/bin

# Theming DE if user chose FULL installation
if [[ $INSTALL_TYPE == "FULL" ]]; then
  if [[ $DESKTOP_ENV == "kde" ]]; then
    cp -r ~/OpenArch/configs/.config/* ~/.config/
    pip install konsave
    konsave -i ~/OpenArch/configs/kde.knsv
    sleep 1
    konsave -a kde
  elif [[ $DESKTOP_ENV == "openbox" ]]; then
    cd ~
    git clone https://github.com/stojshic/dotfiles-openbox
    ./dotfiles-openbox/install-titus.sh
  fi
fi

# 2026 Developer Tools Setup
echo -ne "
-------------------------------------------------------------------------
                    Setting up Developer Tools (Python/Node)
-------------------------------------------------------------------------
"

# Install Gemini CLI if requested
if [[ $GEMINI_CLI == "YES" ]]; then
  echo "Installing Gemini CLI..."
  sudo npm install -g @google/gemini-cli
fi

# Initialize miniconda if installed
if [ -d "/opt/miniconda3" ]; then
    /opt/miniconda3/bin/conda init bash
    /opt/miniconda3/bin/conda init zsh
fi

# Apply Wallpaper if selected
if [[ ! -z $WALLPAPER && ! $WALLPAPER == "default" ]]; then
  echo "Applying selected wallpaper: $WALLPAPER"
  mkdir -p ~/Pictures/Wallpapers
  case $WALLPAPER in
    "arch-dark") WP_URL="https://wallpapercave.com/wp/wp6658145.jpg" ;;
    "modern-blue") WP_URL="https://wallpapercave.com/wp/wp6658156.jpg" ;;
    "minimal-gray") WP_URL="https://wallpapercave.com/wp/wp2519721.jpg" ;;
    "cyberpunk") WP_URL="https://wallpapercave.com/wp/wp4411649.jpg" ;;
  esac
  
  if [[ ! -z $WP_URL ]]; then
    curl -L $WP_URL -o ~/Pictures/Wallpapers/background.jpg
    
    if [[ $DESKTOP_ENV == "kde" ]]; then
      # KDE wallpaper setting (requires plasma-apply-wallpaper-image from plasma-desktop)
      /usr/lib/plasma-apply-wallpaper-image ~/Pictures/Wallpapers/background.jpg
    elif [[ $DESKTOP_ENV == "gnome" ]]; then
      gsettings set org.gnome.desktop.background picture-uri "file:///home/$USERNAME/Pictures/Wallpapers/background.jpg"
      gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USERNAME/Pictures/Wallpapers/background.jpg"
    elif [[ $DESKTOP_ENV == "xfce" ]]; then
      property=$(xfconf-query -c xfce4-desktop -l | grep "last-image" | head -n 1)
      xfconf-query -c xfce4-desktop -p "$property" -s ~/Pictures/Wallpapers/background.jpg
    fi
  fi
fi

# Create a default python venv in home
python -m venv ~/dev-venv
echo "source ~/dev-venv/bin/activate" >> ~/.bashrc
echo "source ~/dev-venv/bin/activate" >> ~/.zshrc

echo "Developer tools (uv, Node.js, Python Venv, Conda) configured."

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
