#!/bin/bash

# Coolify Monitor Installer

# Text formatting
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "${red}Please run as root${normal}"
    echo "Use: sudo bash install-coolify-monitor.sh"
    exit 1
fi

# Source and destination paths
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")/coolify-monitor.sh"
INSTALL_PATH="/usr/local/bin/coolify-monitor"

# Check if source script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "${red}Error: Could not find coolify-monitor.sh${normal}"
    exit 1
fi

# Copy script to installation directory
echo "Installing Coolify Monitor..."
cp "$SCRIPT_PATH" "$INSTALL_PATH"

# Make script executable
chmod +x "$INSTALL_PATH"

# Verify installation
if [ -x "$INSTALL_PATH" ]; then
    echo "${green}Installation successful!${normal}"
    echo
    echo "You can now run the monitor by typing:"
    echo "${bold}coolify-monitor${normal}"
else
    echo "${red}Installation failed${normal}"
    exit 1
fi
