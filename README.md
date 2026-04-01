# Vicon ROS2 Integration

A Dockerized ROS2 Jazzy workspace for receiving and processing motion capture data from a Vicon system.

## Overview

This repository provides a complete setup for interfacing with Vicon motion capture systems using ROS2. It includes a pre-configured Docker environment with all necessary dependencies, launch configurations, and networking setup for real-time data streaming.

## Prerequisites

- Docker and Docker Compose
- Direct ethernet connection to Vicon host machine
- Static IP configuration (see Network Setup below)

## Network Setup

The machine running this ROS2 stack must be connected to the Vicon host machine with a static IP configuration:

| Parameter | Value |
|-----------|-------|
| **IP Address** | `10.10.10.2` |
| **Subnet Mask** | `255.0.0.0` |
| **Vicon Ports** | `801`, `804`, or `8802` |


### Quick Network Setup (Linux)

```bash
sudo nmcli connection modify "Wired connection 1" \
  ipv4.method manual \
  ipv4.addresses 10.10.10.2/8

sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"
```

Verify connectivity:
```bash
ping 10.10.10.1  # Vicon host machine
```

## Quick Start

### 1. Start the Container

```bash
cd docker
./docker_start.sh
```

This script will build the Docker image and start an interactive container session.

### 2. Launch Vicon Receiver

Inside the container, use one of the tmule shortcuts:

```bash
s  # Start tmule session (launches vicon_receiver + rviz2)
t  # Terminate tmule session
r  # Relaunch tmule session
```

Or manually:
```bash
ros2 launch vicon_receiver markers.launch.py
```

## Repository Structure

```
.
├── bash_scripts/       # Container setup and utility scripts
├── configs/            # tmule and RViz configuration files
├── docker/             # Dockerfile and docker-compose.yml
└── ros2-vicon-receiver/  # Vicon receiver ROS2 package (submodule)
```

## Workspace Management

The ROS2 workspace is located at `/home/ros/base_ws` inside the container.

## Visualization

RViz2 is configured to visualize Vicon markers. The configuration file is located at:
```
configs/vicon.rviz
```

## Troubleshooting

### Functions (s, t, r) not available
If the tmule shortcuts don't work on first container start, rebuild the image:
```bash
docker-compose build --no-cache
```

### No Vicon data received
1. Verify network connectivity: `ping 10.10.10.1`
2. Check Vicon host is broadcasting on the correct port (801, 804, or 8802)
3. Verify firewall settings on both machines

### RViz display issues
Ensure X11 forwarding is working:
```bash
xhost +local:docker  # Run on host machine
```

## License

GNU General Public License v3.0

## Credits

Vicon receiver package developed by the OPT4SMART group.
