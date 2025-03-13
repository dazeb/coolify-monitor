# Coolify Monitor

A lightweight system monitoring tool designed specifically for Coolify servers. It provides real-time metrics for both system resources and Docker containers.

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- Real-time system metrics monitoring:
  - CPU usage
  - Memory usage
  - Disk usage
  - System load averages
- Docker container statistics:
  - Container CPU usage
  - Memory consumption
  - Network I/O
  - Block I/O
- Automatic installation and service setup
- System service integration (starts on boot)
- Colored output for better readability
- Error handling and dependency checking

## Quick Install

Install with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/dazeb/coolify-monitor/main/setup-coolify-monitor.sh | sudo bash
```

## Requirements

- Linux-based operating system with systemd
- Docker
- curl
- git

## Manual Installation

If you prefer to inspect the scripts before installation:

1. Clone the repository:
   ```bash
   git clone https://github.com/dazeb/coolify-monitor.git
   cd coolify-monitor
   ```

2. Run the setup script:
   ```bash
   sudo bash setup-coolify-monitor.sh
   ```

## Usage

After installation, the monitor runs as a system service and starts automatically on boot.

### Service Management

```bash
# Check service status
systemctl status coolify-monitor

# Start the service
systemctl start coolify-monitor

# Stop the service
systemctl stop coolify-monitor

# Restart the service
systemctl restart coolify-monitor

# View logs
journalctl -u coolify-monitor
```

### Manual Usage

You can also run the monitor manually at any time:

```bash
coolify-monitor
```

## Output Example

```
=== Coolify Server Monitor ===
Time: 2025-03-13 22:28:19

CPU Usage:
45.2%

Memory Usage:
3.2GB/8.0GB (40.0%)

Disk Usage:
25GB/100GB (25.0%)

Load Averages:
0.52, 0.58, 0.59

Docker Container Stats:
NAME                CPU %     MEM USAGE/LIMIT    NET I/O          BLOCK I/O
coolify             0.15%     125.8MB/8GB        1.5MB/2.8MB      0B/0B
nginx-proxy         0.02%     12.5MB/8GB         782kB/852kB      0B/0B
postgres            0.45%     256.2MB/8GB        15.2MB/22.1MB    0B/0B
```

## Uninstallation

To remove Coolify Monitor:

```bash
sudo systemctl stop coolify-monitor
sudo systemctl disable coolify-monitor
sudo rm /etc/systemd/system/coolify-monitor.service
sudo rm /usr/local/bin/coolify-monitor
sudo systemctl daemon-reload
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any problems or have suggestions, please open an issue on the [GitHub repository](https://github.com/dazeb/coolify-monitor/issues).
