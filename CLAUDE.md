# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository is designed for testing connections and capabilities of Pronghorn, the University of Nevada, Reno's High-Performance Computing (HPC) cluster.

## Pronghorn System Information

### Connection Details
- **Host**: `pronghorn.rc.unr.edu`
- **SSH Command**: `ssh gevangelista@pronghorn.rc.unr.edu`
- **VPN Required**: Must connect to campus VPN for off-campus access
- **Documentation**: https://github.com/UNR-HPC/pronghorn/wiki/1.0-Connecting-to-Pronghorn

### User Directories and Storage
- **Home Directory**: `/data/gpfs/home/gevangelista`
- **Storage Quota**: 50GB (not backed up)
- **Check Usage**: `mmlsquota -j home.gevangelista --block-size 1G pronghorn-0`

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
- **Hackathons**: https://www.unr.edu/research-computing/calendar

## Development Guidelines

### Important Constraints
1. All compute jobs MUST be submitted through SLURM (no direct node access)
2. Always specify account and partition pairs in job submissions
3. Be mindful of job limits and runtime restrictions
4. Data in home directory is NOT backed up

### Best Practices
1. Use the test partition (`cpu-s6-test-0`) for debugging scripts (15-minute limit)
2. Containerize complex software dependencies using Singularity
3. Include proper error handling for queue wait times and resource availability
4. Always check quota before large data operations

## Common Commands

### Job Management
```bash
# Submit a job
sbatch --account=cpu-s3-sponsored-0 --partition=cpu-s3-sponsored-0 script.sh

# Check job status
squeue -u gevangelista

# Cancel a job
scancel <job_id>

# Interactive session (for testing)
salloc --account=cpu-s6-test-0 --partition=cpu-s6-test-0 --time=00:15:00
```

### Storage Management
```bash
# Check quota
mmlsquota -j home.gevangelista --block-size 1G pronghorn-0

# Check disk usage
du -sh /data/gpfs/home/gevangelista
```

## Project-Specific Notes

This testing repository should focus on:
- Connection validation scripts
- SLURM job submission templates
- Container deployment examples
- Data transfer and storage tests
- Performance benchmarking tools
- Documentation of Pronghorn-specific workflows