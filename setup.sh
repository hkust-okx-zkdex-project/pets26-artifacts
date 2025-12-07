#!/bin/bash

# Setup script for PETS26 Artifacts
# This script sets up git submodules and installs required dependencies (Rust 1.80.0 and Go 1.19)
# Designed for Ubuntu systems

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

# Check if running on Ubuntu/Debian
if ! command -v apt-get &> /dev/null; then
    print_warn "This script is designed for Ubuntu/Debian systems. Some commands may need adjustment."
fi

print_info "Starting setup for PETS26 Artifacts..."

# Check if we're in the repository root (look for .gitmodules)
if [ ! -f ".gitmodules" ]; then
    print_error "This script must be run from the repository root directory (where .gitmodules exists)"
    exit 1
fi

# Update package list
print_info "Updating package list..."
sudo apt-get update -qq

# Install basic dependencies
print_info "Installing basic build dependencies..."
sudo apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    libssl-dev \
    ca-certificates \
    gnupg \
    lsb-release

# Check and install Rust 1.80.0
print_info "Checking Rust installation..."
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version | awk '{print $2}')
    print_info "Rust is already installed: $RUST_VERSION"
    
    # Check if version is 1.80.0 or compatible
    # Extract major.minor version
    RUST_MAJOR=$(echo "$RUST_VERSION" | cut -d. -f1)
    RUST_MINOR=$(echo "$RUST_VERSION" | cut -d. -f2)
    
    if [ "$RUST_MAJOR" -gt 1 ] || ([ "$RUST_MAJOR" -eq 1 ] && [ "$RUST_MINOR" -ge 80 ]); then
        print_info "Rust version is compatible (>= 1.80.0)"
    else
        print_warn "Rust version $RUST_VERSION is older than required 1.80.0"
        print_info "Installing Rust 1.80.0 via rustup..."
        if ! command -v rustup &> /dev/null; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
        rustup install 1.80.0
        rustup default 1.80.0
    fi
else
    print_info "Rust is not installed. Installing Rust 1.80.0 via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    rustup install 1.80.0
    rustup default 1.80.0
fi

# Verify Rust installation
RUST_VERSION=$(rustc --version)
print_info "Rust version: $RUST_VERSION"
CARGO_VERSION=$(cargo --version)
print_info "Cargo version: $CARGO_VERSION"

# Function to install Go 1.19
install_go_1_19() {
    GO_VERSION="1.19.13"
    GO_ARCH="linux-amd64"
    GO_TAR="go${GO_VERSION}.${GO_ARCH}.tar.gz"
    GO_URL="https://go.dev/dl/${GO_TAR}"
    
    # Remove existing Go installation if in /usr/local/go
    if [ -d "/usr/local/go" ]; then
        print_info "Removing existing Go installation..."
        sudo rm -rf /usr/local/go
    fi
    
    # Download and install Go
    print_info "Downloading Go ${GO_VERSION}..."
    cd /tmp
    curl -LO "$GO_URL"
    
    print_info "Installing Go ${GO_VERSION}..."
    sudo tar -C /usr/local -xzf "$GO_TAR"
    rm "$GO_TAR"
    
    # Add Go to PATH if not already there
    if ! grep -q '/usr/local/go/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
        export PATH=$PATH:/usr/local/go/bin
    fi
    
    # Also add to current session
    export PATH=$PATH:/usr/local/go/bin
}

# Check and install Go 1.19
print_info "Checking Go installation..."
if command -v go &> /dev/null; then
    GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    print_info "Go is already installed: $GO_VERSION"
    
    # Check if version is 1.19 or compatible
    GO_MAJOR=$(echo "$GO_VERSION" | cut -d. -f1)
    GO_MINOR=$(echo "$GO_VERSION" | cut -d. -f2)
    
    if [ "$GO_MAJOR" -gt 1 ] || ([ "$GO_MAJOR" -eq 1 ] && [ "$GO_MINOR" -ge 19 ]); then
        print_info "Go version is compatible (>= 1.19)"
    else
        print_warn "Go version $GO_VERSION is older than required 1.19"
        print_info "Installing Go 1.19..."
        install_go_1_19
    fi
else
    print_info "Go is not installed. Installing Go 1.19..."
    install_go_1_19
fi

# Verify Go installation
GO_VERSION=$(go version)
print_info "Go version: $GO_VERSION"

# Setup git submodules
print_info "Initializing and updating git submodules..."
git submodule update --init --recursive

# Verify submodules are initialized
print_info "Verifying submodules..."
git submodule status

# Download Rust dependencies (optional, but helpful to verify)
print_info "Downloading Rust dependencies for verification..."
if [ -f "ark-iesp/Cargo.toml" ]; then
    print_info "Fetching dependencies for ark-iesp..."
    cd ark-iesp
    cargo fetch
    cd ..
fi

if [ -f "halo2/Cargo.toml" ]; then
    print_info "Fetching dependencies for halo2..."
    cd halo2
    cargo fetch
    cd ..
fi

if [ -f "halo2-link-circuit/Cargo.toml" ]; then
    print_info "Fetching dependencies for halo2-link-circuit..."
    cd halo2-link-circuit
    cargo fetch
    cd ..
fi

# Download Go dependencies (optional, but helpful to verify)
print_info "Downloading Go dependencies for verification..."
if [ -f "rsa_accumulator/go.mod" ]; then
    print_info "Downloading dependencies for rsa_accumulator..."
    cd rsa_accumulator
    go mod download
    cd ..
fi

if [ -f "VTLP/go.mod" ]; then
    print_info "Downloading dependencies for VTLP..."
    cd VTLP
    go mod download
    cd ..
fi

print_info ""
print_info "=========================================="
print_info "Setup completed successfully!"
print_info "=========================================="
print_info ""
print_info "Installed versions:"
print_info "  Rust: $(rustc --version)"
print_info "  Cargo: $(cargo --version)"
print_info "  Go: $(go version)"
print_info ""
print_info "Git submodules initialized:"
git submodule status
print_info ""
print_info "Note: If you opened a new terminal, you may need to run:"
print_info "  source ~/.cargo/env  # For Rust"
print_info "  export PATH=\$PATH:/usr/local/go/bin  # For Go (or restart terminal)"
print_info ""
print_info "You can now build the projects:"
print_info "  Rust projects: cd <project> && cargo build"
print_info "  Go projects: cd <project> && go build"
print_info ""

