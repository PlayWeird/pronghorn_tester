#!/bin/bash
# Check storage quota on Pronghorn

# Get username from environment or use default
USERNAME=${USER:-"YOUR_NETID"}

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