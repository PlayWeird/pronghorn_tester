#!/bin/bash
#SBATCH --job-name=quick_test
#SBATCH --account=cpu-s6-test-0
#SBATCH --partition=cpu-s6-test-0
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=logs/slurm/test_%j.out
#SBATCH --error=logs/slurm/test_%j.err

# Quick test job for Pronghorn
# This uses the test partition with 15-minute time limit

echo "Quick Test Job Started"
echo "======================"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $SLURM_NODELIST"
echo "Start Time: $(date)"
echo ""

# Basic system information
echo "System Information:"
echo "-------------------"
echo "Hostname: $(hostname)"
echo "CPU Info:"
lscpu | grep -E "Model name|CPU\(s\)|Thread|Core|Socket"
echo ""

# Memory information
echo "Memory Information:"
echo "-------------------"
free -h
echo ""

# Test Python availability
echo "Python Test:"
echo "------------"
if command -v python3 &> /dev/null; then
    python3 --version
    python3 -c "import sys; print(f'Python path: {sys.executable}')"
else
    echo "Python3 not found in PATH"
fi
echo ""

# Test module system
echo "Module System Test:"
echo "-------------------"
if command -v module &> /dev/null; then
    echo "Available modules:"
    module avail 2>&1 | head -20
else
    echo "Module system not available"
fi
echo ""

# Simple computation test
echo "Simple Computation Test:"
echo "------------------------"
echo "Calculating pi to 1000 decimal places..."
start_time=$(date +%s.%N)
echo "scale=1000; 4*a(1)" | bc -l > /dev/null 2>&1
end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)
echo "Computation completed in $elapsed seconds"
echo ""

echo "End Time: $(date)"
echo "Job completed successfully!"