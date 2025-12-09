#!/bin/bash

# Script to run Experiment 6: EdDSA benchmark
# This experiment runs the EdDSA benchmark

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the script directory and repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
RESULTS_DIR="$REPO_ROOT/results"

# Create results directory if it doesn't exist
print_info "Creating results directory if it doesn't exist..."
mkdir -p "$RESULTS_DIR"

# Check if we're in the repository root
if [ ! -d "rsa_accumulator" ]; then
    print_error "This script must be run from the repository root directory"
    exit 1
fi

# Check if the experiment directory exists
if [ ! -d "rsa_accumulator" ]; then
    print_error "Experiment directory rsa_accumulator not found"
    exit 1
fi

# Check if Go is installed
if ! command -v go &> /dev/null; then
    print_error "Go is not installed. Please run setup.sh first."
    exit 1
fi

# Generate output filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="$RESULTS_DIR/experiment_7_rsa_${TIMESTAMP}.txt"

print_info "Starting Experiment 7: RSA accumulator and MultiSwap benchmark"
print_info "Output will be saved to: $OUTPUT_FILE"
print_info ""

# Change to the experiment directory
cd "$REPO_ROOT/rsa_accumulator"

# Build the Go program
print_info "Building Go program..."
go build -o rsa_accumulator

# Check if test executable exists after build
if [ ! -f "./rsa_accumulator" ] && [ ! -f "./rsa_accumulator.exe" ]; then
    print_error "Build failed: test executable not found"
    exit 1
fi

# Determine the executable name (rsa_accumulator or rsa_accumulator.exe)
if [ -f "./rsa_accumulator" ]; then
    TEST_EXEC="./rsa_accumulator"
elif [ -f "./rsa_accumulator.exe" ]; then
    TEST_EXEC="./rsa_accumulator.exe"
fi

# Run the experiment and capture output
print_info "Running: $TEST_EXEC"
print_info "This may take a while..."

# Run the command and capture both stdout and stderr
{
    echo "=========================================="
    echo "Experiment 7: RSA accumulator and MultiSwap"
    echo "Timestamp: $(date)"
    echo "Command: $TEST_EXEC"
    echo "=========================================="
    echo ""
    
    $TEST_EXEC 2>&1
    
    echo ""
    echo "=========================================="
    echo "Experiment completed at: $(date)"
    echo "=========================================="
} | tee "$OUTPUT_FILE"

print_info ""
print_info "Experiment completed successfully!"
print_info "Results saved to: $OUTPUT_FILE"
print_info ""
