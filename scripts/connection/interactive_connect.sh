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
echo "Command: ssh YOUR_NETID@pronghorn.rc.unr.edu"
echo "-----------------------------------"
echo "Note: Replace YOUR_NETID with your actual NetID"
echo ""

# Get username from environment or prompt user
USERNAME=${PRONGHORN_USER:-""}

if [ -z "$USERNAME" ]; then
    echo "❌ NetID not configured!"
    echo ""
    echo "Please set your NetID using one of these methods:"
    echo "  1. Set environment variable: export PRONGHORN_USER=your_netid"
    echo "  2. Replace placeholder in files: sed -i 's/YOUR_NETID/your_netid/g' scripts/connection/interactive_connect.sh"
    echo ""
    echo "Then run this script again."
    exit 1
fi

# Connect with SSH
ssh ${USERNAME}@pronghorn.rc.unr.edu