#!/bin/bash

# Check if we are on macOS or Linux
OS=$(uname)

# Installing dependencies
echo "Installing dependencies..."

if [ "$OS" == "Linux" ]; then
    echo "Detected Linux..."

    # Install Neovim using the AppImage
    if ! command -v nvim &> /dev/null
    then
        echo "Neovim not found, installing it using AppImage..."
        
        # Download the latest Neovim AppImage
        wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O /tmp/nvim.appimage
        
        # Make it executable
        chmod u+x /tmp/nvim.appimage
        
        # Move it to /usr/local/bin
        sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
        
        echo "Neovim installed successfully via AppImage!"
    else
        echo "Neovim already installed!"
    fi

    # Install pip (for Python provider)
    if ! command -v pip3 &> /dev/null
    then
        echo "pip3 not found, installing it now..."
        sudo apt install -y python3-pip
    else
        echo "pip3 already installed!"
    fi

    # Install npm (for Node.js and LSP-related plugins)
    if ! command -v npm &> /dev/null
    then
        echo "npm not found, installing it now..."
        sudo apt install -y npm
    else
        echo "npm already installed!"
    fi

    # Install xclip (for clipboard support)
    if ! command -v xclip &> /dev/null
    then
        echo "Installing xclip for clipboard support..."
        sudo apt install -y xclip
    else
        echo "xclip already installed!"
    fi

elif [ "$OS" == "Darwin" ]; then
    echo "Detected macOS..."

    # Install Neovim using Homebrew
    if ! command -v nvim &> /dev/null
    then
        echo "Neovim not found, installing via Homebrew..."
        brew install neovim
    else
        echo "Neovim already installed!"
    fi

    # Install pip (for Python provider)
    if ! command -v pip3 &> /dev/null
    then
        echo "pip3 not found, installing it now..."
        brew install python
    else
        echo "pip3 already installed!"
    fi

    # Install npm (for Node.js and LSP-related plugins)
    if ! command -v npm &> /dev/null
    then
        echo "npm not found, installing it now..."
        brew install node
    else
        echo "npm already installed!"
    fi
fi

# Install pynvim (Python provider for Neovim)
pip3 install --user pynvim

# Install tree-sitter CLI (for nvim-treesitter)
if ! command -v tree-sitter &> /dev/null
then
    echo "Installing tree-sitter..."
    sudo npm install -g tree-sitter-cli
else
    echo "tree-sitter already installed!"
fi

# Backup existing Neovim config if it exists
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing Neovim configuration..."
    mkdir -p "$HOME/dotfiles_backup"
    mv "$HOME/.config/nvim" "$HOME/dotfiles_backup/nvim_$(date +%F_%T)"
fi

# Create the Neovim config directory if it doesn't exist
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Creating Neovim config directory..."
    mkdir -p "$HOME/.config/nvim"
fi

# Symlink the Neovim config
echo "Symlinking the Neovim configuration..."
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

# Install packer.nvim (plugin manager) if it's not installed
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo "Installing packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
else
    echo "packer.nvim already installed!"
fi

# Install Python LSP (pyright)
if ! command -v pyright &> /dev/null
then
    echo "Installing Python LSP (pyright)..."
    sudo npm install -g pyright
else
    echo "pyright already installed!"
fi

# Install C/C++ LSP (clangd)
if ! command -v clangd &> /dev/null
then
    if [ "$OS" == "Linux" ]; then
        echo "Installing C/C++ LSP (clangd)..."
        sudo apt install -y clangd
    elif [ "$OS" == "Darwin" ]; then
        echo "Installing C/C++ LSP (clangd) via Homebrew..."
        brew install llvm
    fi
else
    echo "clangd already installed!"
fi

# Install HTML, CSS, and JSON LSP (vscode-langservers-extracted)
if ! command -v vscode-html-language-server &> /dev/null
then
    echo "Installing HTML/CSS/JSON LSP..."
    sudo npm install -g vscode-langservers-extracted
else
    echo "HTML/CSS/JSON LSP already installed!"
fi

# Install Bash LSP (bash-language-server)
if ! command -v bash-language-server &> /dev/null
then
    echo "Installing Bash LSP..."
    sudo npm install -g bash-language-server
else
    echo "Bash LSP already installed!"
fi

# Install Nerd Fonts (Optional but useful for status lines and icons)
if [ ! -d "$HOME/.local/share/fonts/NerdFonts" ]; then
    echo "Installing Nerd Fonts..."
    mkdir -p "$HOME/.local/share/fonts/NerdFonts"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O /tmp/Hack.zip
    unzip /tmp/Hack.zip -d "$HOME/.local/share/fonts/NerdFonts"
    fc-cache -fv
    echo "Nerd Fonts installed!"
else
    echo "Nerd Fonts already installed!"
fi

# Run Neovim to install plugins
echo "Installing Neovim plugins with Packer..."
nvim --headless +PackerSync +qa

# Update Neovim plugins to ensure the latest versions are installed
echo "Updating Neovim plugins..."
nvim --headless +PackerUpdate +qa

# Shell check for sourcing the correct shell config
if [[ $SHELL == *"zsh"* ]]; then
    echo "Detected zsh shell, sourcing .zshrc"
    source ~/.zshrc
elif [[ $SHELL == *"bash"* ]]; then
    echo "Detected bash shell, sourcing .bashrc"
    source ~/.bashrc
fi

echo "Setup complete! Enjoy your Neovim environment!"

