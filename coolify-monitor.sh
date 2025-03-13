#!/bin/bash

# Coolify Server Monitor
# Displays basic system metrics and Docker container stats

# Text formatting
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)

# Print header
print_header() {
    echo "${bold}${blue}=== Coolify Server Monitor ===${normal}"
    echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "---------------------------------"
}

# Get CPU usage
get_cpu_info() {
    echo "${bold}CPU Usage:${normal}"
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{printf "%.1f%%\n", $1}'
    echo
}

# Get memory usage
get_memory_info() {
    echo "${bold}Memory Usage:${normal}"
    free -h | awk 'NR==2{printf "%s/%s (%.1f%%)\n", $3,$2,($3/$2)*100}'
    echo
}

# Get disk usage
get_disk_info() {
    echo "${bold}Disk Usage:${normal}"
    df -h / | awk 'NR==2{printf "%s/%s (%.1f%%)\n", $3,$2,($3/$2)*100}'
    echo
}

# Get load averages
get_load_averages() {
    echo "${bold}Load Averages:${normal}"
    uptime | awk -F'load average: ' '{print $2}'
    echo
}

# Get Docker stats
get_docker_stats() {
    echo "${bold}Docker Container Stats:${normal}"
    # Check if docker is running
    if ! docker info >/dev/null 2>&1; then
        echo "${red}Docker is not running${normal}"
        return
    fi
    # Get stats for all running containers
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
}

# Main function
main() {
    clear
    print_header
    get_cpu_info
    get_memory_info
    get_disk_info
    get_load_averages
    get_docker_stats
}

# Run main function
main
