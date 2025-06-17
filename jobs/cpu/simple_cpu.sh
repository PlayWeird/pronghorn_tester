#!/bin/bash
#SBATCH --job-name=simple_cpu_job
#SBATCH --account=cpu-s3-sponsored-0
#SBATCH --partition=cpu-s3-sponsored-0
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --output=logs/slurm/cpu_%j.out
#SBATCH --error=logs/slurm/cpu_%j.err

# Simple CPU job template for Pronghorn
# Demonstrates basic SLURM directives and job structure

echo "Simple CPU Job Started"
echo "======================"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $SLURM_NODELIST"
echo "CPUs: $SLURM_CPUS_PER_TASK"
echo "Memory: $SLURM_MEM_PER_NODE MB"
echo "Start Time: $(date)"
echo ""

# Load any required modules
# module load python/3.9  # Example - uncomment and modify as needed

# Set up environment
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Change to working directory
cd $SLURM_SUBMIT_DIR

# Your computation goes here
echo "Running computation..."

# Example: Python script
if [ -f "benchmarks/cpu/cpu_bench.py" ]; then
    python3 benchmarks/cpu/cpu_bench.py
else
    # Fallback example computation
    echo "Performing matrix multiplication test..."
    python3 << 'EOF'
import numpy as np
import time

size = 2000
print(f"Creating two {size}x{size} random matrices...")
A = np.random.rand(size, size)
B = np.random.rand(size, size)

print("Performing matrix multiplication...")
start = time.time()
C = np.dot(A, B)
end = time.time()

print(f"Matrix multiplication completed in {end-start:.2f} seconds")
print(f"Result matrix shape: {C.shape}")
print(f"Result matrix sum: {np.sum(C):.2f}")
EOF
fi

echo ""
echo "End Time: $(date)"
echo "Job completed!"