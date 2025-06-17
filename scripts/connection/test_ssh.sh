#!/bin/bash
# Test SSH connection to Pronghorn

# Get username from environment or use default
USERNAME=${USER:-"YOUR_NETID"}

echo "Testing SSH connection to Pronghorn HPC cluster..."
echo "================================================="
echo "Using username: $USERNAME"
echo ""

# Check if we can reach the host
echo -n "Checking network connectivity to pronghorn.rc.unr.edu... "
if ping -c 1 -W 5 pronghorn.rc.unr.edu > /dev/null 2>&1; then
    echo "✓ Host is reachable"
else
    echo "✗ Host is not reachable"
    echo "Please check your network connection and VPN status"
    exit 1
fi

# Test SSH connection
echo -n "Testing SSH connection... "
if ssh -o ConnectTimeout=10 -o BatchMode=yes ${USERNAME}@pronghorn.rc.unr.edu 'echo "SSH connection successful"' 2>/dev/null; then
    echo "✓ SSH connection successful"
    
    # Get some basic info
    echo ""
    echo "Gathering system information..."
    ssh ${USERNAME}@pronghorn.rc.unr.edu 'echo "Hostname: $(hostname)"; echo "Current directory: $(pwd)"; echo "Username: $(whoami)"'
else
    echo "✗ SSH connection failed"
    echo ""
    echo "Possible issues:"
    echo "1. VPN not connected (required for off-campus access)"
    echo "2. SSH key not set up"
    echo "3. Incorrect username or credentials"
    echo "4. Username not updated in script"
    echo ""
    echo "Try connecting manually: ssh ${USERNAME}@pronghorn.rc.unr.edu"
    echo "Or update the USERNAME variable in this script"
    exit 1
fi

echo ""
echo "Connection test completed successfully!"