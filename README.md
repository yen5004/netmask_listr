# Subnet IP Scanner
Script used to find the IP range using subnet and 1 IP address.

## Description
This script calculates all the IPs within a given subnet based on a known IP address and a specified subnet mask. It then scans these IPs and provides information on which IPs are active (responding to ping) and which are inactive.

## Features
- Calculates network and broadcast addresses based on a known IP and subnet mask.
- Scans IP addresses within the subnet, excluding network and broadcast addresses.
- Provides a summary of active and inactive IPs within the subnet.

## Prerequisites
Before using the script, please check and update the following lines:
- **Known IP Address**: Modify the `KNOWN_IP` variable to your specific known IP address.
  ```bash
  KNOWN_IP="10.10.252.146"
  ```

- **Subnet Mask**: Update the `NETMASK` variable to your desired subnet mask.
  ```bash
  NETMASK="255.255.0.0"
  ```

## Installation
1. **Clone the Repository**: Clone this repository to your local machine. Give proper permissions
   ```bash
   sudo git clone https://github.com/yen5004/subnet-ip-scanner.git
   cd subnet-ip-scanner
   sudo chmod 777 subnet_findr.sh
   ```

2. **Ensure Dependencies**: Ensure `fping` is installed on your system.
   ```bash
   sudo apt-get install fping
   ```

## Usage
1. **Update the Script**: Before running the script, ensure you have updated the `KNOWN_IP` and `NETMASK` variables with your network details.

2. **Run the Script**: Execute the script using the terminal.
   ```bash
   ./subnet_findr.sh
   ```

3. **View the Results**: The script will calculate the subnet IP range, scan the IPs, and provide a summary of active and inactive IPs. It will also list the active IPs that responded to the ping.

## Example Output
```text
Network address: 10.10.0.0
Broadcast address: 10.10.255.255
Total IPs to scan: 65534

--- Scan Summary ---
Network address: 10.10.0.0
Broadcast address: 10.10.255.255
Total IPs expected to scan: 65534
Total IPs scanned: 65534
Usable IPs: 65534
Reserved IPs (Network + Broadcast): 2
Active IPs (Responded to Ping): 2
Inactive IPs (Did not respond to Ping): 65532
Scan completed in 120 seconds.

Active IPs:
10.10.252.146
10.10.252.147
```

## Notes
- Ensure you have the appropriate permissions to scan the network.
- The script is optimized for Linux environments.

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
