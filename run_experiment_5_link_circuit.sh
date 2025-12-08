#!/bin/bash

# Script to run Experiment 5: The link circuit (combine Plonk with groth16)
# This experiment runs the end-to-end benchmark with multiple parameter combinations

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
if [ ! -d "halo2-link-circuit" ]; then
    print_error "This script must be run from the repository root directory"
    exit 1
fi

# Check if the experiment directory exists
if [ ! -d "halo2-link-circuit/bench/end-to-end" ]; then
    print_error "Experiment directory halo2-link-circuit/bench/end-to-end not found"
    exit 1
fi

# Check if batch_run.sh exists
if [ ! -f "halo2-link-circuit/bench/end-to-end/batch_run.sh" ]; then
    print_error "batch_run.sh not found in halo2-link-circuit/bench/end-to-end"
    exit 1
fi

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    print_error "Cargo is not installed. Please run setup.sh first."
    exit 1
fi

# Generate output filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="$RESULTS_DIR/experiment_5_link_circuit_${TIMESTAMP}.txt"
LOG_PREFIX="experiment_5_link_circuit_${TIMESTAMP}"

print_info "Starting Experiment 5: The link circuit (combine Plonk with groth16)"
print_info "This experiment tests multiple parameter combinations with multiple iterations"
print_info "Output will be saved to: $OUTPUT_FILE"
print_info ""

# Change to the experiment directory
cd "$REPO_ROOT/halo2-link-circuit/bench/end-to-end"

# Make batch_run.sh executable if it isn't already
chmod +x batch_run.sh

# Run the batch experiment and capture output
print_info "Running: ./batch_run.sh $LOG_PREFIX"
print_info "This will test 5 parameter combinations with 5 iterations each"
print_info "This may take a while..."

# Run the batch_run.sh script and capture output
{
    echo "=========================================="
    echo "Experiment 5: The link circuit (combine Plonk with groth16)"
    echo "Timestamp: $(date)"
    echo "Command: ./batch_run.sh $LOG_PREFIX"
    echo "=========================================="
    echo ""
    echo "This experiment tests the following parameter combinations:"
    echo "  - k=11, poly_degree=1024"
    echo "  - k=12, poly_degree=2048"
    echo "  - k=13, poly_degree=4096"
    echo "  - k=14, poly_degree=8192"
    echo "  - k=15, poly_degree=16384"
    echo "Each combination will run 5 iterations for statistical reliability."
    echo ""
    
    ./batch_run.sh "$LOG_PREFIX" 2>&1
    
    echo ""
    echo "=========================================="
    echo "Batch runs completed. Aggregating results..."
    echo "=========================================="
    echo ""
    
    # Aggregate all individual log files into the main output
    for log_file in ${LOG_PREFIX}_k*_deg*.log; do
        if [ -f "$log_file" ]; then
            echo "=== Contents of $log_file ==="
            cat "$log_file"
            echo ""
            echo "=========================================="
            echo ""
        fi
    done
    
    echo "=========================================="
    echo "Experiment completed at: $(date)"
    echo "=========================================="
} | tee "$OUTPUT_FILE"

# Move individual log files to results directory for reference
print_info "Moving individual log files to results directory..."
for log_file in ${LOG_PREFIX}_k*_deg*.log; do
    if [ -f "$log_file" ]; then
        mv "$log_file" "$RESULTS_DIR/"
        print_info "  Moved: $log_file"
    fi
done

print_info ""
print_info "Experiment completed successfully!"
print_info "Main results saved to: $OUTPUT_FILE"
print_info "Individual parameter pair logs saved to: $RESULTS_DIR/"
print_info ""

