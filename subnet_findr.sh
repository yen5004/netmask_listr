#!/bin/bash

# Known IP address (replace this with your own known IP)
KNOWN_IP="10.10.252.146"  # Change this to your known IP

# Subnet Mask
NETMASK="255.255.0.0"

# Convert known IP and netmask to integers for easy manipulation
IP_TO_INT() {
    local ip=$1
    local a b c d
    IFS=. read -r a b c d <<< "$ip"
    echo $((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))
}

# Convert netmask to integer
NETMASK_TO_INT() {
    local netmask=$1
    local a b c d
    IFS=. read -r a b c d <<< "$netmask"
    echo $((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))
}

# Get the network address from the known IP and subnet mask
KNOWN_IP_INT=$(IP_TO_INT "$KNOWN_IP")
NETMASK_INT=$(NETMASK_TO_INT "$NETMASK")
NETWORK_ADDR=$((KNOWN_IP_INT & NETMASK_INT))

# Get the broadcast address (network address + inverted netmask)
INVERTED_NETMASK=$((~NETMASK_INT & 0xFFFFFFFF))
BROADCAST_ADDR=$((NETWORK_ADDR | INVERTED_NETMASK))

# Convert back to dotted decimal format for printing
NETWORK_ADDR_DOT=$(printf "%d.%d.%d.%d" $((NETWORK_ADDR >> 24 & 255)) $((NETWORK_ADDR >> 16 & 255)) $((NETWORK_ADDR >> 8 & 255)) $((NETWORK_ADDR & 255)))
BROADCAST_ADDR_DOT=$(printf "%d.%d.%d.%d" $((BROADCAST_ADDR >> 24 & 255)) $((BROADCAST_ADDR >> 16 & 255)) $((BROADCAST_ADDR >> 8 & 255)) $((BROADCAST_ADDR & 255)))

# Print out calculated network range for debugging
echo "Network address: $NETWORK_ADDR_DOT"
echo "Broadcast address: $BROADCAST_ADDR_DOT"

# Calculate the total number of IPs to be scanned (Excluding network and broadcast address)
if [ $BROADCAST_ADDR -gt $NETWORK_ADDR ]; then
    IP_COUNT=$((BROADCAST_ADDR - NETWORK_ADDR - 1))
else
    IP_COUNT=0
fi

# Initialize counters
total_ips=0
active_ips=0
inactive_ips=0
reserved_ips=2  # Network address and Broadcast address
usable_ips=0
active_ip_list=()  # List to store active IPs

# Debugging: Show the calculated IP count
echo "Total IPs to scan: $IP_COUNT"

# Start the scan timer
start_time=$(date +%s)

# Loop over all IP addresses in the subnet, but avoid scanning the network and broadcast address
for ip_int in $(seq $((NETWORK_ADDR + 1)) $((BROADCAST_ADDR - 1))); do
    # Convert the IP address back to the dotted format
    ip=$(printf "%d.%d.%d.%d" $((ip_int >> 24 & 255)) $((ip_int >> 16 & 255)) $((ip_int >> 8 & 255)) $((ip_int & 255)))

    # Increment the total IP count
    total_ips=$((total_ips + 1))

    # Increment usable IPs
    usable_ips=$((usable_ips + 1))

    # Output the IP being pinged for debugging
    echo "Pinging IP: $ip"

    # Run fping and capture output
    if fping -c 1 -t 100 $ip >/dev/null 2>&1; then
        echo "$ip is reachable"
        active_ips=$((active_ips + 1))
        active_ip_list+=("$ip")  # Add the active IP to the list
    else
        echo "$ip is not reachable"
        inactive_ips=$((inactive_ips + 1))
    fi
done

# End the scan timer
end_time=$(date +%s)

# Calculate the time taken for the scan
elapsed_time=$((end_time - start_time))

# Print summary at the end
echo -e "\n--- Scan Summary ---"
echo "Network address: $NETWORK_ADDR_DOT"
echo "Broadcast address: $BROADCAST_ADDR_DOT"
echo "Total IPs expected to scan: $IP_COUNT"
echo "Total IPs scanned: $total_ips"
echo "Usable IPs: $usable_ips"
echo "Reserved IPs (Network + Broadcast): $reserved_ips"
echo "Active IPs (Responded to Ping): $active_ips"
echo "Inactive IPs (Did not respond to Ping): $inactive_ips"
echo "Scan completed in $elapsed_time seconds."

# List of active IPs
if [ $active_ips -gt 0 ]; then
    echo -e "\nActive IPs:"
    for active_ip in "${active_ip_list[@]}"; do
        echo "$active_ip"
    done
else
    echo "No active IPs found."
fi
