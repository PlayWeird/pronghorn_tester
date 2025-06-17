#!/bin/bash
# Interactive connection script for Pronghorn

echo "==================================="
echo "Pronghorn HPC Connection Assistant"
echo "==================================="
echo ""

# Check if we can reach Pronghorn
echo -n "Checking if Pronghorn is reachable... "
if ping -c 1 -W 5 pronghorn.rc.unr.edu > /dev/null 2>&1; then
    echo "✓ Yes"
else
    echo "✗ No"
    echo ""
    echo "Cannot reach Pronghorn. Please ensure:"
    echo "1. You are connected to the internet"
    echo "2. You are on campus OR connected to UNR VPN"
    echo ""
    echo "To connect to VPN:"
    echo "- Use your VPN client to connect to UNR's VPN service"
    echo "- Then run this script again"
    exit 1
fi

echo ""
echo "Attempting to connect to Pronghorn..."
echo "You may be prompted for your NetID password."
echo ""
echo "Command: ssh gevangelista@pronghorn.rc.unr.edu"
echo "-----------------------------------"

# Connect with SSH
ssh gevangelista@pronghorn.rc.unr.edu