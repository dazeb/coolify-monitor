#!/bin/bash

# Setup script for Coolify Monitor
# Downloads and installs the monitoring tools from github.com/dazeb/coolify-monitor

# Text formatting
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)

# Repository URL
REPO_URL="https://github.com/dazeb/coolify-monitor"
TEMP_DIR="/tmp/coolify-monitor"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "${red}Please run as root${normal}"
    echo "Use: sudo bash setup-coolify-monitor.sh"
    exit 1
fi

# Check for required dependencies
check_dependencies() {
    local deps=("curl" "git" "docker")
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done

    if [ ${#missing[@]} -ne 0 ]; then
        echo "${red}Missing required dependencies: ${missing[*]}${normal}"
        echo "Please install the missing dependencies and try again."
        exit 1
    fi
}

# Download monitor scripts from GitHub
download_scripts() {
    echo "${blue}Downloading Coolify Monitor scripts...${normal}"
    
    # Remove existing temp directory if it exists
    rm -rf "$TEMP_DIR"
    
    # Clone the repository
    if ! git clone "$REPO_URL" "$TEMP_DIR"; then
        echo "${red}Failed to download scripts from GitHub${normal}"
        exit 1
    fi
}

# Install the monitor
install_monitor() {
    echo "${blue}Installing Coolify Monitor...${normal}"
    
    # Copy scripts to /usr/local/bin
    cp "$TEMP_DIR/coolify-monitor.sh" "/usr/local/bin/coolify-monitor"
    chmod +x "/usr/local/bin/coolify-monitor"
    
    # Verify installation
    if [ ! -x "/usr/local/bin/coolify-monitor" ]; then
        echo "${red}Installation failed${normal}"
        exit 1
    fi
}

# Create systemd service for automatic startup
create_service() {
    echo "${blue}Creating systemd service...${normal}"
    
    cat > /etc/systemd/system/coolify-monitor.service << EOL
[Unit]
Description=Coolify Server Monitor
After=network.target docker.service

[Service]
Type=simple
ExecStart=/usr/local/bin/coolify-monitor
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

    # Reload systemd daemon
    systemctl daemon-reload
    
    # Enable and start the service
    systemctl enable coolify-monitor.service
    systemctl start coolify-monitor.service
    
    # Check service status
    if ! systemctl is-active --quiet coolify-monitor.service; then
        echo "${red}Failed to start coolify-monitor service${normal}"
        exit 1
    fi
}

# Cleanup
cleanup() {
    echo "${blue}Cleaning up...${normal}"
    rm -rf "$TEMP_DIR"
}

# Main installation process
main() {
    echo "${bold}${blue}=== Coolify Monitor Setup ===${normal}"
    
    # Run installation steps
    check_dependencies
    download_scripts
    install_monitor
    create_service
    cleanup
    
    # Success message
    echo
    echo "${green}Coolify Monitor has been successfully installed and enabled!${normal}"
    echo
    echo "The monitor is now running as a service and will start automatically on boot."
    echo "You can:"
    echo "- Check the status: ${bold}systemctl status coolify-monitor${normal}"
    echo "- View the logs: ${bold}journalctl -u coolify-monitor${normal}"
    echo "- Run manually: ${bold}coolify-monitor${normal}"
}

# Run main function
main
