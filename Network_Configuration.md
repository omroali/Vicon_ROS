# Network Configuration Reference

## Overview
Direct ethernet connection between Linux and Windows machines for high-speed data transfer.

## Hardware Setup
- **Connection Type**: Direct connection via Cat6a cable
- **Linux Interface**: enp56s0
- **Windows Interface**: 10 GbE network card
- **Cable**: Cat6a (supports up to 10 Gbps)

## IP Configuration

| Machine | IP Address   | Subnet Mask | Gateway | DNS |
|---------|--------------|-------------|---------|-----|
| Linux   | 10.10.10.1   | 255.0.0.0   | None    | None|
| Windows | 10.10.10.2   | 255.0.0.0   | None    | None|

**Subnet**: /8 (255.0.0.0)  
**Network Range**: 10.0.0.0 - 10.255.255.255

## Linux Configuration

### System Information
- **OS**: Arch Linux
- **Network Manager**: NetworkManager
- **Connection Profile**: "Wired connection 1"

### Applied Configuration
```bash
sudo nmcli connection modify "Wired connection 1" \
  ipv4.method manual \
  ipv4.addresses 10.10.10.1/8

sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"
```

### Verification Commands
```bash
# Check interface status
ip addr show enp56s0

# Test connectivity
ping -c 4 10.10.10.2

# View connection details
nmcli connection show "Wired connection 1"

# Check physical link
cat /sys/class/net/enp56s0/carrier  # 1 = connected, 0 = disconnected
```

### Restart Connection
```bash
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"
```

## Windows Configuration

### Method
Configured via Control Panel (ncpa.cpl)

### Settings
1. Open: `Win + R` → `ncpa.cpl`
2. Right-click Ethernet adapter → Properties
3. Internet Protocol Version 4 (TCP/IPv4) → Properties
4. Set:
   - IP address: 10.10.10.2
   - Subnet mask: 255.0.0.0
   - Default gateway: (empty)
   - DNS: (empty)

### Verification
```cmd
ipconfig
ping 10.10.10.1
```

## Troubleshooting

### Connection Test Results
Expected ping latency: < 1ms  
Observed: ~0.3ms (normal)

### Common Issues

**No connectivity:**
- Check physical cable connection
- Verify Windows firewall allows ICMP (ping)
- Ensure network profile is "Private" on Windows
- Confirm IP settings are saved on both machines

**Linux interface not coming up:**
```bash
sudo nmcli connection up "Wired connection 1"
sudo systemctl restart NetworkManager
```

**Clear ARP cache (if needed):**
```bash
sudo ip neigh flush dev enp56s0
```

**Check ARP table:**
```bash
ip neigh show
```

### Reset to DHCP (if needed)
```bash
sudo nmcli connection modify "Wired connection 1" ipv4.method auto
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"
```

## Notes
- Connection is independent of WiFi/internet
- No gateway required for direct connection
- Subnet mask 255.0.0.0 (/8) allows entire 10.x.x.x range
- Configuration persists across reboots
- Designed for ROS2 Vicon data streaming
