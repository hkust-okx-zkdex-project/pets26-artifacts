#!/bin/bash

# Script to run Experiment 2: Plonk + matrix lookup (2 fan-in gates, powered by matrix lookup)
# This experiment runs the sublonk benchmark for Figure 4(a), Figure 4(b), Figure 4(c), Figure 4(d)

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
if [ ! -d "halo2/sublonk" ]; then
    print_error "Experiment directory halo2/sublonk not found"
    exit 1
fi

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    print_error "Cargo is not installed. Please run setup.sh first."
    exit 1
fi

# Generate output filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="$RESULTS_DIR/experiment_2_plonk_matrix_lookup_${TIMESTAMP}.txt"

print_info "Starting Experiment 2: Plonk + matrix lookup (2 fan-in gates, powered by matrix lookup)"
print_info "This experiment is for Figure 4(a), Figure 4(b), Figure 4(c), Figure 4(d)"
print_info "Output will be saved to: $OUTPUT_FILE"
print_info ""

# Change to the experiment directory
cd "$REPO_ROOT/halo2/sublonk"

# Run the experiment and capture output
print_info "Running: cargo run --release"
print_info "This may take a while..."

# Run the command and capture both stdout and stderr
{
    echo "=========================================="
    echo "Experiment 2: Plonk + matrix lookup (2 fan-in gates, powered by matrix lookup)"
    echo "For Figure 4(a), Figure 4(b), Figure 4(c), Figure 4(d)"
    echo "Timestamp: $(date)"
    echo "Command: cargo run --release"
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

