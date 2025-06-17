#!/bin/bash
# Check storage quota on Pronghorn

# Get username from environment or prompt user
USERNAME=${PRONGHORN_USER:-""}

if [ -z "$USERNAME" ]; then
    echo "❌ NetID not configured!"
    echo ""
    echo "Please set your NetID using one of these methods:"
    echo "  1. Set environment variable: export PRONGHORN_USER=your_netid"
    echo "  2. Replace placeholder in files: sed -i 's/YOUR_NETID/your_netid/g' scripts/utilities/quota_check.sh"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "Checking storage quota for user: $USERNAME"
echo "============================================"

# SSH to Pronghorn and check quota
ssh ${USERNAME}@pronghorn.rc.unr.edu << EOF
echo "Home directory quota:"
mmlsquota -j home.$USERNAME --block-size 1G pronghorn-0

echo ""
echo "Current disk usage:"
du -sh /data/gpfs/home/$USERNAME 2>/dev/null || echo "Unable to check disk usage"

echo ""
echo "Top 5 largest directories:"
du -h /data/gpfs/home/$USERNAME/* 2>/dev/null | sort -rh | head -5
EOF