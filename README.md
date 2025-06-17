# Pronghorn HPC Testing Repository

A comprehensive testing framework for the Pronghorn High-Performance Computing cluster at the University of Nevada, Reno.

## Prerequisites

- **NetID Account**: Valid UNR NetID with Pronghorn access
- **VPN Access**: UNR VPN client (required for off-campus connections)
- **SSH Client**: Terminal with SSH support (built-in on Linux/macOS, use PuTTY on Windows)
- **Local Tools**: `make`, `git`, Python 3.x (optional for local testing)

## Quick Start

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd pronghorn_tester
   ```

2. **Set up permissions**:
   ```bash
   make setup
   ```

3. **Test your connection**:
   ```bash
   make test-connection
   # or directly: bash scripts/connection/test_ssh.sh
   ```

4. **Check your storage quota**:
   ```bash
   make check-quota
   # or directly: bash scripts/utilities/quota_check.sh
   ```

## Project Structure

```
pronghorn_tester/
├── scripts/                 # Utility scripts
│   ├── connection/         # Connection testing (test_ssh.sh, vpn_check.sh)
│   ├── utilities/          # Helper scripts (quota_check.sh, module_list.sh)
│   └── setup/              # Setup scripts (setup_env.sh, install_deps.sh)
├── jobs/                    # SLURM job scripts
│   ├── cpu/                # CPU job templates (simple_cpu.sh, mpi_job.sh)
│   ├── gpu/                # GPU job templates (gpu_test.sh)
│   ├── array/              # Array job templates (array_job.sh)
│   └── test/               # Quick test jobs (quick_test.sh - 15 min limit)
├── containers/              # Singularity containers
│   ├── definitions/        # Container definitions (python.def, ml_env.def)
│   └── scripts/            # Container management (build.sh, run.sh)
├── benchmarks/              # Performance tests
│   ├── cpu/                # CPU benchmarks (cpu_bench.py)
│   ├── gpu/                # GPU benchmarks (gpu_bench.py)
│   └── io/                 # I/O benchmarks (io_bench.py)
├── data/                    # Data directories
│   ├── input/              # Input files for jobs
│   └── output/             # Job output files
├── logs/                    # Log files
│   ├── slurm/              # SLURM output/error files
│   └── application/        # Application-specific logs
├── config/                  # Configuration files
├── docs/                    # Additional documentation
└── .ssh/                    # SSH configuration
```

## Connecting to Pronghorn

### Manual Connection
```bash
# Connect from on-campus
ssh gevangelista@pronghorn.rc.unr.edu

# Connect from off-campus (VPN required)
# 1. First connect to UNR VPN
# 2. Then SSH to Pronghorn
ssh gevangelista@pronghorn.rc.unr.edu
```

### Using SSH Config (Recommended)
```bash
# With the provided .ssh/config, you can simply use:
ssh pronghorn
```

## Running Jobs on Pronghorn

### 1. Quick Test Job (15-minute limit)
Perfect for testing your setup and debugging:
```bash
# Submit a quick test job
sbatch jobs/test/quick_test.sh

# Check job status
squeue -u gevangelista

# View output (replace JOBID with your actual job ID)
cat logs/slurm/test_JOBID.out
```

### 2. Standard CPU Job
For regular computational work (up to 8 hours):
```bash
# Submit CPU job
sbatch jobs/cpu/simple_cpu.sh

# Monitor job
squeue -u gevangelista

# Cancel if needed
scancel JOBID
```

### 3. Interactive Session
For development and testing:
```bash
# Request 15-minute interactive session on test partition
salloc --account=cpu-s6-test-0 --partition=cpu-s6-test-0 --time=00:15:00

# Once allocated, you'll be on a compute node
# Run your commands here
python3 my_script.py

# Exit when done
exit
```

## Using Containers

### Building a Singularity Container
```bash
# On Pronghorn (or local machine with Singularity)
cd containers/definitions
singularity build ../python.sif python.def
```

### Running Container Jobs
```bash
# In your job script, use:
singularity run containers/python.sif my_script.py
```

## Storage Management

### Check Your Quota
```bash
# Using the utility script
make check-quota

# Or directly on Pronghorn
mmlsquota -j home.gevangelista --block-size 1G pronghorn-0
```

### Important Paths
- **Home Directory**: `/data/gpfs/home/gevangelista` (50GB limit, not backed up)
- **Applications**: `/apps` (system-wide software)
- **Scratch Space**: Check with your research group

## Common Workflows

### 1. Testing New Code
```bash
# 1. Edit your code locally
vim my_analysis.py

# 2. Copy to Pronghorn
scp my_analysis.py pronghorn:~/

# 3. Submit test job
ssh pronghorn
sbatch --account=cpu-s6-test-0 --partition=cpu-s6-test-0 jobs/test/quick_test.sh
```

### 2. Running a Python Analysis
```bash
# 1. Prepare your data
cp mydata.csv data/input/

# 2. Modify the job script
vim jobs/cpu/simple_cpu.sh
# Update to run your Python script

# 3. Submit the job
sbatch jobs/cpu/simple_cpu.sh

# 4. Check results
ls data/output/
cat logs/slurm/cpu_*.out
```

### 3. Batch Processing with Array Jobs
```bash
# For processing multiple files/parameters
sbatch jobs/array/array_job.sh
```

## Available Commands (Makefile)

```bash
make help              # Show all available commands
make test-connection   # Test SSH connection to Pronghorn
make check-quota       # Check storage quota
make setup            # Initial setup and permissions
make permissions      # Fix script permissions
make clean            # Clean output and log files
```

## SLURM Cheat Sheet

```bash
# Submit job
sbatch script.sh

# Check queue
squeue -u gevangelista

# Check all your jobs
squeue -u gevangelista -t all

# Cancel job
scancel JOBID

# Cancel all your jobs
scancel -u gevangelista

# View account info
sacctmgr show associations user=gevangelista

# Job history
sacct -u gevangelista --starttime=2024-01-01
```

## Troubleshooting

### Connection Issues
1. **"Connection refused"**: Check VPN connection (off-campus)
2. **"Permission denied"**: Verify your NetID and password
3. **"Host not found"**: Check network connectivity

### Job Issues
1. **Job pending too long**: Check partition limits and availability
2. **Job failed immediately**: Check SLURM error files in `logs/slurm/`
3. **Out of memory**: Increase memory request in job script

### Storage Issues
1. **Quota exceeded**: Run `make check-quota` and clean up files
2. **Permission denied**: Check file ownership and permissions

## Best Practices

1. **Always use the test partition** (`cpu-s6-test-0`) for debugging
2. **Monitor your quota** regularly to avoid job failures
3. **Use containers** for complex software dependencies
4. **Save important data** outside your home directory (not backed up!)
5. **Clean up** after jobs complete to save space

## Support

- **Wiki**: https://github.com/UNR-HPC/pronghorn/wiki
- **Email**: hpc@unr.edu
- **Slack**: https://unrrc.slack.com
- **Hackathons**: Weekly sessions - https://www.unr.edu/research-computing/calendar

## Next Steps

1. Run `make test-connection` to verify access
2. Submit a test job with `sbatch jobs/test/quick_test.sh`
3. Explore the example scripts and modify for your needs
4. Join the Slack channel for community support