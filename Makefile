# Makefile for Pronghorn HPC Testing

.PHONY: help test-connection check-quota setup permissions clean

help:
	@echo "Pronghorn HPC Testing - Available commands:"
	@echo "  make test-connection  - Test SSH connection to Pronghorn"
	@echo "  make check-quota      - Check storage quota on Pronghorn"
	@echo "  make setup           - Initial setup and permissions"
	@echo "  make permissions     - Fix script permissions"
	@echo "  make clean           - Clean output and log files"

test-connection:
	@bash scripts/connection/test_ssh.sh

check-quota:
	@bash scripts/utilities/quota_check.sh

setup: permissions
	@echo "Setting up Pronghorn testing environment..."
	@mkdir -p logs/slurm logs/application
	@echo "Setup complete!"

permissions:
	@echo "Setting executable permissions on scripts..."
	@find scripts -name "*.sh" -type f -exec chmod +x {} \;
	@find jobs -name "*.sh" -type f -exec chmod +x {} \;
	@find containers/scripts -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
	@chmod 600 .ssh/config 2>/dev/null || true
	@echo "Permissions updated!"

clean:
	@echo "Cleaning output and log files..."
	@rm -f logs/slurm/*.out logs/slurm/*.err
	@rm -f logs/application/*.log
	@rm -rf data/output/*
	@echo "Clean complete!"