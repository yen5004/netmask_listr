#!/bin/bash

# Known IP address (replace this with your own known IP)
KNOWN_IP="192.168.1.10"  # Change this to your known IP

# Subnet Mask
NETMASK="255.255.225.224"

# Convert known IP and netmask to integers for easy manipulation
IP_TO_INT() {
    local ip=$1
    local a b c d
    IFS=. read -r a b c d <<< "$ip"
    echo $((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))
}

# Get the network address from the known IP and subnet mask
NETWORK_ADDR=$(IP_TO_INT "$KNOWN_IP" & $(IP_TO_INT "$NETMASK"))

# Get the broadcast address (network address + inverted netmask)
INVERTED_NETMASK=$((~(NETMASK & 255)))
BROADCAST_ADDR=$((NETWORK_ADDR | INVERTED_NETMASK))

# Loop over all IP addresses in the subnet
for ip_int in $(seq NETWORK_ADDR BROADCAST_ADDR); do
    # Convert the IP address to the integer from a subnet
    fping $ip_int
done
