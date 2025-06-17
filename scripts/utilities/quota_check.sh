#!/bin/bash
# Check storage quota on Pronghorn

echo "Checking storage quota for user: gevangelista"
echo "============================================"

# SSH to Pronghorn and check quota
ssh gevangelista@pronghorn.rc.unr.edu << 'EOF'
echo "Home directory quota:"
mmlsquota -j home.gevangelista --block-size 1G pronghorn-0

echo ""
echo "Current disk usage:"
du -sh /data/gpfs/home/gevangelista 2>/dev/null || echo "Unable to check disk usage"

echo ""
echo "Top 5 largest directories:"
du -h /data/gpfs/home/gevangelista/* 2>/dev/null | sort -rh | head -5
EOF