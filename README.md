# Pronghorn HPC Testing Repository

A comprehensive testing framework for the Pronghorn High-Performance Computing cluster at the University of Nevada, Reno.

## Prerequisites

- **NetID Account**: Valid UNR NetID with Pronghorn access
- **VPN Access**: UNR VPN client (required for off-campus connections)
- **SSH Client**: Terminal with SSH support (built-in on Linux/macOS, use PuTTY on Windows)
- **Local Tools**: `make`, `git`, Python 3.x (optional for local testing)

## Quick Start

### First-time Setup
Before using this repository, you need to customize it for your account:

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd pronghorn_tester
   ```

2. **Update configuration files with your NetID**:
   ```bash
   # Replace YOUR_NETID with your actual NetID throughout the repository
   # For example, if your NetID is "jsmith":
   
   # sed: find "YOUR_NETID" and replace with "jsmith" in SSH config
   sed -i 's/YOUR_NETID/jsmith/g' .ssh/config
   
   # find: locate all .sh files and run sed on each one
   find scripts/ -name "*.sh" -exec sed -i 's/YOUR_NETID/jsmith/g' {} \;
   
   # Update container definitions too
   find containers/ -name "*.def" -exec sed -i 's/YOUR_NETID/jsmith/g' {} \;
   
   # Alternative: Set environment variable (scripts will use this automatically)
   export PRONGHORN_USER=jsmith
   ```

3. **Set up permissions**:
   ```bash
   make setup
   ```

4. **Check your account associations** (on Pronghorn):
   ```bash
   # ssh: connect to Pronghorn cluster
   ssh YOUR_NETID@pronghorn.rc.unr.edu
   
   # sacctmgr: show which accounts/partitions you can use
   sacctmgr show associations user=YOUR_NETID format=account,partition,qos
   ```

### Testing Your Setup

1. **Test your connection**:
   ```bash
   make test-connection
   # or directly: bash scripts/connection/test_ssh.sh
   ```

2. **Check your storage quota**:
   ```bash
   make check-quota
   # or directly: bash scripts/utilities/quota_check.sh
   ```

## Project Structure

```
pronghorn_tester/
├── scripts/                 # Utility scripts
│   ├── connection/         # Connection testing
│   │   ├── test_ssh.sh     # SSH connectivity test
│   │   └── interactive_connect.sh  # Interactive connection helper
│   ├── utilities/          # Helper scripts
│   │   ├── quota_check.sh  # Storage quota checker
│   │   └── check_gpu_access.sh  # GPU availability checker
│   └── setup/              # Setup scripts
│       └── first_time_check.sh  # Environment validation
├── jobs/                    # SLURM job scripts
│   ├── cpu/                # CPU job templates
│   │   └── simple_cpu.sh   # Basic CPU job template
│   ├── gpu/                # GPU job templates (for future use)
│   ├── array/              # Array job templates (for future use)
│   └── test/               # Quick test jobs
│       └── quick_test.sh   # 15-minute test job
├── containers/              # Singularity containers
│   ├── definitions/        # Container definitions
│   │   └── python.def      # Python container definition
│   └── scripts/            # Container management (for future use)
├── benchmarks/              # Performance tests (for future use)
│   ├── cpu/                # CPU benchmarks
│   ├── gpu/                # GPU benchmarks  
│   └── io/                 # I/O benchmarks
├── data/                    # Data directories
│   ├── input/              # Input files for jobs
│   └── output/             # Job output files
├── logs/                    # Log files (created during job execution)
├── config/                  # Configuration files (for future use)
├── docs/                    # Additional documentation (for future use)
├── .ssh/                    # SSH configuration
│   └── config              # SSH client configuration template
├── Makefile                # Automation commands
├── CLAUDE.md               # AI assistant guidance
└── README.md               # This file
```

## Connecting to Pronghorn

### Manual Connection
```bash
# Connect from on-campus (replace YOUR_NETID with your actual NetID)
ssh YOUR_NETID@pronghorn.rc.unr.edu

# Connect from off-campus (VPN required)
# 1. First connect to UNR VPN
# 2. Then SSH to Pronghorn
ssh YOUR_NETID@pronghorn.rc.unr.edu
```

### Using SSH Config (Recommended)
First, update the `.ssh/config` file with your NetID, then:
```bash
# With the provided .ssh/config (after updating with your NetID), you can simply use:
ssh pronghorn
```

## Running Jobs on Pronghorn

⚠️ **CRITICAL**: Always specify account and partition explicitly on the command line. Using only `#SBATCH` directives in scripts will fail.

⚠️ **ACCOUNT SETUP**: The examples below use `cpu-s6-test-0` and `cpu-s3-sponsored-0` partitions. Check your actual account associations with:
```bash
# sacctmgr: list your available accounts and partitions
sacctmgr show associations user=YOUR_NETID format=account,partition,qos
```
Replace the account/partition names in examples with your actual available accounts.

### 1. Quick Test Job (15-minute limit) - TESTED ✅
Perfect for testing your setup and debugging:
```bash
# CORRECT: sbatch with explicit account/partition (TESTED - WORKS)
sbatch --account=cpu-s6-test-0 --partition=cpu-s6-test-0 jobs/test/quick_test.sh

# WRONG: This will fail with "Invalid account or account/partition combination"
sbatch jobs/test/quick_test.sh

# squeue: check status of your submitted jobs
squeue -u YOUR_NETID

# find: locate job output files (they may be in submission directory)
find ~ -name "*JOBID*" -type f 2>/dev/null

# ls: list SLURM output files in current directory
ls -la slurm-*.out

# cat: view the job output (replace JOBID with actual job number)
cat slurm-JOBID.out
```

### 2. Standard CPU Job - TESTED ✅
For regular computational work (up to 8 hours):
```bash
# sbatch: submit CPU job with explicit account/partition
sbatch --account=cpu-s3-sponsored-0 --partition=cpu-s3-sponsored-0 jobs/cpu/simple_cpu.sh

# squeue: monitor job status
squeue -u YOUR_NETID

# scancel: cancel a job if needed (replace JOBID with actual job number)
scancel JOBID
```

### 3. Interactive Session - TESTED ✅
For development and testing:
```bash
# salloc: request 15-minute interactive session on test partition
salloc --account=cpu-s6-test-0 --partition=cpu-s6-test-0 --time=00:15:00

# Once allocated, you'll be on a compute node
# python: run your scripts (note: use 'python' not 'python3')
python my_script.py

# exit: leave the interactive session when done
exit
```

## Using Containers - TESTED ✅

### Singularity Containers (Fully Functional)
Tested on June 17, 2025 - Singularity 3.6.1 works on both login and compute nodes.

```bash
# singularity pull: download container from Docker Hub (TESTED - WORKS)
singularity pull docker://python:3.9-slim

# singularity exec: run command inside container
singularity exec python_3.9-slim.sif python --version

# sbatch: submit containerized job to SLURM (TESTED - WORKS)
sbatch --account=cpu-s6-test-0 --partition=cpu-s6-test-0 container_job.sh
```

### Building Custom Containers
```bash
# cd: navigate to container definitions directory
cd containers/definitions

# singularity build: create container from definition file
singularity build ../python.sif python.def
```

### Container Job Example
```bash
# singularity exec: run your script inside the container
singularity exec python_3.9-slim.sif python my_script.py
```

## Storage Management

### Check Your Quota
```bash
# make: run the automated quota check script
make check-quota

# mmlsquota: directly check quota on Pronghorn (replace YOUR_NETID)
mmlsquota -j home.YOUR_NETID --block-size 1G pronghorn-0
```

### Important Paths
- **Home Directory**: `/data/gpfs/home/YOUR_NETID` (50GB limit, not backed up)
- **Applications**: `/apps` (system-wide software)
- **Scratch Space**: Check with your research group

## Common Workflows

### 1. Testing New Code
```bash
# vim: edit your code locally
vim my_analysis.py

# scp: copy file to Pronghorn (using SSH config alias)
scp my_analysis.py pronghorn:~/

# ssh: connect to Pronghorn and submit test job
ssh pronghorn
sbatch --account=cpu-s6-test-0 --partition=cpu-s6-test-0 jobs/test/quick_test.sh
```

### 2. Running a Python Analysis
```bash
# cp: prepare your data
cp mydata.csv data/input/

# vim: modify the job script to run your Python script
vim jobs/cpu/simple_cpu.sh

# sbatch: submit the job (remember explicit account/partition)
sbatch --account=cpu-s3-sponsored-0 --partition=cpu-s3-sponsored-0 jobs/cpu/simple_cpu.sh

# ls: check results in output directory
ls data/output/

# find: locate recent SLURM output files
find ~ -name "slurm-*.out" | tail -5
```

### 3. Batch Processing with Array Jobs
```bash
# Array job templates are available in jobs/array/ for future development
# Create your own array job script based on SLURM array job documentation
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
# sbatch: submit job (remember to use explicit account/partition flags)
sbatch --account=ACCOUNT --partition=PARTITION script.sh

# squeue: check current job queue
squeue -u YOUR_NETID

# squeue: check all your jobs (including completed)
squeue -u YOUR_NETID -t all

# scancel: cancel a specific job
scancel JOBID

# scancel: cancel all your jobs
scancel -u YOUR_NETID

# sacctmgr: view your account info and permissions
sacctmgr show associations user=YOUR_NETID

# sacct: view job history from a specific date
sacct -u YOUR_NETID --starttime=2024-01-01
```

## Troubleshooting

### Connection Issues
1. **"Connection refused"**: Check VPN connection (off-campus)
2. **"Permission denied"**: Verify your NetID and password
3. **"Host not found"**: Check network connectivity

### Job Issues
1. **"Invalid account or account/partition combination"**: ALWAYS use explicit `--account` and `--partition` flags
2. **Job pending too long**: Check partition limits and availability
3. **Job failed immediately**: Check SLURM error files with `find ~ -name "*JOBID*"`
4. **Output files not found**: Look in submission directory, not logs/slurm/ 
5. **Out of memory**: Increase memory request in job script

### Storage Issues
1. **Quota exceeded**: Run `make check-quota` and clean up files
2. **Permission denied**: Check file ownership and permissions

## Validation Results (June 17, 2025)

✅ **Successfully Tested and Working**:
- SSH connection from campus
- SLURM job submission on both partitions:
  - `cpu-s3-sponsored-0` (8-hour limit, nodes cpu-64+)
  - `cpu-s6-test-0` (15-minute limit, nodes cpu-65+)  
- Singularity containers (version 3.6.1)
- Bidirectional data transfer via scp
- Storage quota checking
- Job monitoring and output retrieval

⚠️ **Important Findings**:
- Must use explicit `--account` and `--partition` flags for job submission
- Output files created in submission directory, not logs/slurm/
- Use `python` command, not `python3`
- Both partitions require explicit specification to work

## Best Practices

1. **Always specify account/partition** explicitly: `--account=X --partition=X`
2. **Use the test partition** (`cpu-s6-test-0`) for debugging (15-minute limit)
3. **Monitor your quota** regularly to avoid job failures
4. **Use containers** for complex software dependencies
5. **Save important data** outside your home directory (not backed up!)
6. **Clean up** after jobs complete to save space

## Support

- **Wiki**: https://github.com/UNR-HPC/pronghorn/wiki
- **Email**: hpc@unr.edu
- **Slack**: https://unrrc.slack.com
- **Research Computing**: https://www.unr.edu/research-computing

## Next Steps

1. **Customize for your account**: Update NetID in configuration files as described in Quick Start
2. **Verify access**: Run `make test-connection` to test SSH connectivity
3. **Check your accounts**: Run `sacctmgr show associations user=YOUR_NETID format=account,partition,qos` on Pronghorn
4. **Submit test job**: Use your actual account/partition: `sbatch --account=YOUR_ACCOUNT --partition=YOUR_PARTITION jobs/test/quick_test.sh`
5. **Explore and customize**: Modify the example scripts for your specific computational needs
6. **Get support**: Join the Slack channel for community support and questions

Remember to always use explicit `--account` and `--partition` flags when submitting jobs!