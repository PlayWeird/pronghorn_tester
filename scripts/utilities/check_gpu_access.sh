#!/bin/bash
# Check GPU availability and access on Pronghorn

echo "=============================="
echo "Pronghorn GPU Access Check"
echo "=============================="
echo ""

echo "1. CHECKING GPU PARTITIONS"
echo "---------------------------"
echo "Available partitions with 'gpu' in name:"
scontrol show partition | grep -A10 "PartitionName.*gpu" || echo "No GPU partitions found with 'gpu' in name"
echo ""

echo "2. CHECKING ALL PARTITIONS"
echo "---------------------------"
echo "All available partitions:"
sinfo -o "%P %a %l %D %t %N"
echo ""

echo "3. CHECKING YOUR ACCOUNT ASSOCIATIONS"
echo "-------------------------------------"
echo "Your account associations:"
sacctmgr show associations user=$(whoami) format=account,partition,qos
echo ""

echo "4. CHECKING FOR GPU NODES"
echo "-------------------------"
echo "Nodes with GPU features:"
scontrol show nodes | grep -B2 -A5 -i gpu || echo "No nodes found with GPU in description"
echo ""

echo "5. CHECKING NODE FEATURES"
echo "-------------------------"
echo "All node features available:"
sinfo -o "%N %f" | sort -u
echo ""

echo "6. CHECKING GRES (Generic Resources)"
echo "------------------------------------"
echo "Available GRES (including GPUs):"
scontrol show nodes | grep -i gres | sort -u || echo "No GRES information found"
echo ""

echo "=============================="
echo "GPU Check Complete"
echo "=============================="