# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository is designed for testing connections and capabilities of Pronghorn, the University of Nevada, Reno's High-Performance Computing (HPC) cluster.

## Pronghorn System Information

### Connection Details
- **Host**: `pronghorn.rc.unr.edu`
- **SSH Command**: `ssh YOUR_NETID@pronghorn.rc.unr.edu`
- **VPN Required**: Must connect to campus VPN for off-campus access
- **Documentation**: https://github.com/UNR-HPC/pronghorn/wiki/1.0-Connecting-to-Pronghorn

### User Directories and Storage
- **Home Directory**: `/data/gpfs/home/YOUR_NETID`
- **Storage Quota**: 50GB (not backed up)
- **Check Usage**: `mmlsquota -j home.YOUR_NETID --block-size 1G pronghorn-0`

### Job Scheduler - SLURM
- **Default Account/Partition**: `cpu-s3-sponsored-0/cpu-s3-sponsored-0`
- **Available Account/Partition Pairs**:
  - `cpu-s3-sponsored-0/cpu-s3-sponsored-0`: Max 12 jobs, 1 node, 8 hours runtime
  - `cpu-s6-test-0/cpu-s6-test-0`: Max 2 jobs, 2 nodes, 15 minutes runtime (for testing)
- **Job Submission Example**: `sbatch --account=cpu-s3-sponsored-0 --partition=cpu-s3-sponsored-0 script.sh`
- **SLURM Documentation**: https://slurm.schedmd.com/documentation.html
- **SLURM Tutorials**: https://slurm.schedmd.com/tutorials.html

### Software Environment
- **System Applications**: Located in `/apps` directory
- **Container System**: Singularity/Apptainer containers (preferred method)
- **Container Documentation**: https://www.sylabs.io/docs/
- **Module System**: Available for loading pre-installed software

### Support Resources
- **Wiki**: https://github.com/UNR-HPC/pronghorn/wiki
- **Website**: https://www.unr.edu/research-computing
- **Slack**: https://unrrc.slack.com
- **Email**: hpc@unr.edu

## Development Guidelines

### Important Constraints
1. All compute jobs MUST be submitted through SLURM (no direct node access)
2. Always specify account and partition pairs in job submissions
3. Be mindful of job limits and runtime restrictions
4. Data in home directory is NOT backed up

### Critical Job Submission Rules (TESTED)
⚠️ **IMPORTANT**: Job submission requires explicit account/partition specification:
- ✅ **WORKING**: `sbatch --account=cpu-s3-sponsored-0 --partition=cpu-s3-sponsored-0 script.sh`
- ✅ **WORKING**: `sbatch --account=cpu-s6-test-0 --partition=cpu-s6-test-0 script.sh`
- ❌ **FAILS**: Using only `#SBATCH` directives in script without command-line flags
- ❌ **FAILS**: `sbatch script.sh` (without explicit account/partition)

### Tested System Capabilities
1. **Both Partitions Functional** (June 17, 2025):
   - `cpu-s3-sponsored-0`: Runs on nodes cpu-64+ (8-hour limit)
   - `cpu-s6-test-0`: Runs on nodes cpu-65+ (15-minute limit)
2. **Singularity Containers**: Fully functional on compute nodes (version 3.6.1)
3. **Python**: Use `python` (not `python3`) or load via modules
4. **Data Transfer**: scp works bidirectionally

### Best Practices
1. Use the test partition (`cpu-s6-test-0`) for debugging scripts (15-minute limit)
2. Always specify account/partition on command line, not just in script
3. Containerize complex software dependencies using Singularity
4. Include proper error handling for queue wait times and resource availability
5. Always check quota before large data operations

## Common Commands

### Job Management
```bash
# Submit a job (TESTED - WORKING FORMAT)
sbatch --account=cpu-s3-sponsored-0 --partition=cpu-s3-sponsored-0 script.sh
sbatch --account=cpu-s6-test-0 --partition=cpu-s6-test-0 script.sh

# Check job status
squeue -u YOUR_NETID

# Check job history and details
sacct -j <job_id> --format=JobID,JobName,State,ExitCode,Submit,Start,End
scontrol show job <job_id>

# Cancel a job
scancel <job_id>

# Interactive session (for testing)
salloc --account=cpu-s6-test-0 --partition=cpu-s6-test-0 --time=00:15:00

# Find job output files
find ~ -name "*<job_id>*" -type f 2>/dev/null
```

### Storage Management
```bash
# Check quota
mmlsquota -j home.YOUR_NETID --block-size 1G pronghorn-0

# Check disk usage
du -sh /data/gpfs/home/YOUR_NETID
```

### Container Management (TESTED)
```bash
# Pull container from Docker Hub
singularity pull docker://python:3.9-slim

# Run container interactively
singularity exec python_3.9-slim.sif python --version

# Run container in SLURM job
singularity exec python_3.9-slim.sif python script.py
```

### Account Management
```bash
# Check your account associations (full names)
sacctmgr list associations user=YOUR_NETID format=account%20,partition%20 --parsable2

# Check available partitions
scontrol show partition | grep -A5 "PartitionName=cpu"
sinfo
```

## Project-Specific Notes

This testing repository should focus on:
- Connection validation scripts
- SLURM job submission templates
- Container deployment examples
- Data transfer and storage tests
- Performance benchmarking tools
- Documentation of Pronghorn-specific workflows