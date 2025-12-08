#!/bin/bash

# Script to run Experiment 3: Matrix lookup according to the number of distinct segments selected
# This experiment runs the ark-segmentlookup benchmark for Figure 4(b)

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
if [ ! -d "halo2" ]; then
    print_error "This script must be run from the repository root directory"
    exit 1
fi

# Check if the experiment directory exists
if [ ! -d "ark-segmentlookup" ]; then
    print_error "Experiment directory ark-segmentlookup not found"
    exit 1
fi

if [ ! -d "ark-segmentlookup/bench/end_to_end" ]; then
    print_error "Experiment directory ark-segmentlookup/bench/end_to_end not found"
    exit 1
fi

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    print_error "Cargo is not installed. Please run setup.sh first."
    exit 1
fi

# Generate output filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="$RESULTS_DIR/experiment_3_plonk_segments_${TIMESTAMP}.txt"

print_info "Starting Experiment 3: Matrix lookup according to the number of distinct segments selected"
print_info "This experiment is for Figure 4(b)"
print_info "Output will be saved to: $OUTPUT_FILE"
print_info ""

# Change to the experiment directory
cd "$REPO_ROOT/ark-segmentlookup/bench/end_to_end"

# Update dependencies before building
print_info "Updating Cargo dependencies..."
cargo update

# Run the experiment and capture output
print_info "Running: cargo run --release"
print_info "This may take a while..."

# Run the command and capture both stdout and stderr
{
    echo "=========================================="
    echo "Experiment 3: Matrix lookup according to the number of distinct segments selected"
    echo "For Figure 4(b)"
    echo "Timestamp: $(date)"
    echo "Command: cargo run --release"
    echo "Working directory: ark-segmentlookup/bench/end_to_end"
    echo "=========================================="
    echo ""
    
    cargo run --release 2>&1
    
    echo ""
    echo "=========================================="
    echo "Experiment completed at: $(date)"
    echo "=========================================="
} | tee "$OUTPUT_FILE"

print_info ""
print_info "Experiment completed successfully!"
print_info "Results saved to: $OUTPUT_FILE"
print_info ""

