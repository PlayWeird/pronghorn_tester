#!/bin/bash
# First-time Pronghorn environment check
# Run this script after successfully connecting to Pronghorn

echo "======================================"
echo "Pronghorn First-Time Environment Check"
echo "======================================"
echo ""

# Basic info
echo "1. BASIC INFORMATION"
echo "--------------------"
echo "Hostname: $(hostname)"
echo "Username: $(whoami)"
echo "Current directory: $(pwd)"
echo "Home directory: $HOME"
echo ""

# Check quota
echo "2. STORAGE QUOTA"
echo "----------------"
echo "Checking your storage quota..."
mmlsquota -j home.$(whoami) --block-size 1G pronghorn-0 2>/dev/null || echo "Unable to check quota"
echo ""

# Check available modules
echo "3. MODULE SYSTEM"
echo "----------------"
echo "Checking if module system is available..."
if command -v module &> /dev/null; then
    echo "Module system is available!"
    echo ""
    echo "Sample of available modules:"
    module avail 2>&1 | head -20
else
    echo "Module system not found in current environment"
fi
echo ""

# Check SLURM
echo "4. SLURM SCHEDULER"
echo "------------------"
echo "Checking SLURM availability..."
if command -v sbatch &> /dev/null; then
    echo "SLURM is available!"
    echo ""
    echo "Your account associations:"
    sacctmgr show associations user=$(whoami) 2>/dev/null || echo "Unable to check associations"
    echo ""
    echo "Current queue status:"
    squeue -u $(whoami) 2>/dev/null || echo "No jobs in queue"
else
    echo "SLURM commands not found"
fi
echo ""

# Check Python
echo "5. PYTHON ENVIRONMENT"
echo "---------------------"
if command -v python3 &> /dev/null; then
    python3 --version
    echo "Python3 location: $(which python3)"
else
    echo "Python3 not found in default PATH"
fi
echo ""

# Check Singularity
echo "6. SINGULARITY/APPTAINER"
echo "------------------------"
if command -v singularity &> /dev/null; then
    singularity --version
elif command -v apptainer &> /dev/null; then
    apptainer --version
else
    echo "Neither Singularity nor Apptainer found in PATH"
fi
echo ""

# Create test directory
echo "7. CREATING TEST DIRECTORY"
echo "--------------------------"
TEST_DIR="$HOME/pronghorn_test_$(date +%Y%m%d)"
if [ ! -d "$TEST_DIR" ]; then
    mkdir -p "$TEST_DIR"
    echo "Created test directory: $TEST_DIR"
else
    echo "Test directory already exists: $TEST_DIR"
fi
echo ""

echo "======================================"
echo "Initial check complete!"
echo ""
echo "Next steps:"
echo "1. Review the output above for any issues"
echo "2. Copy your test scripts to Pronghorn"
echo "3. Submit a test job using the test partition"
echo "======================================"