#!/bin/bash

# Setup script for PETS26 Artifacts
# This script sets up git submodules and installs required dependencies (Rust 1.82.0 and Go 1.19)
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

# Save the original directory
ORIGINAL_DIR=$(pwd)
print_info "Working directory: $ORIGINAL_DIR"

# Track if we made changes that require sourcing
MADE_BASHRC_CHANGES=false
MADE_CARGO_CHANGES=false
MADE_PROFILE_CHANGES=false

# Function to add cargo env sourcing to shell config files
add_cargo_env_to_shell_config() {
    local config_file="$1"
    local cargo_env_line='. "$HOME/.cargo/env"'
    
    if [ -f "$config_file" ]; then
        if ! grep -qF '. "$HOME/.cargo/env"' "$config_file" && ! grep -qF 'source "$HOME/.cargo/env"' "$config_file"; then
            echo "" >> "$config_file"
            echo "# Rust/Cargo environment" >> "$config_file"
            echo "$cargo_env_line" >> "$config_file"
            return 0
        fi
    else
        # Create the file if it doesn't exist
        echo "# Rust/Cargo environment" >> "$config_file"
        echo "$cargo_env_line" >> "$config_file"
        return 0
    fi
    return 1
}

# Function to add Go to PATH in shell config files
add_go_to_path_in_shell_config() {
    local config_file="$1"
    local go_path_line='export PATH=$PATH:/usr/local/go/bin'
    
    if [ -f "$config_file" ]; then
        if ! grep -qF '/usr/local/go/bin' "$config_file"; then
            echo "" >> "$config_file"
            echo "# Go binary path" >> "$config_file"
            echo "$go_path_line" >> "$config_file"
            return 0
        fi
    else
        # Create the file if it doesn't exist
        echo "# Go binary path" >> "$config_file"
        echo "$go_path_line" >> "$config_file"
        return 0
    fi
    return 1
}

# Check if we're in the repository root (look for .gitmodules)
if [ ! -f ".gitmodules" ]; then
    print_warn "No .gitmodules file found. This might not be a git repository."
    print_warn "If you downloaded this as a zip file, the submodules may already be included."
fi

# Check if this is a git repository
IS_GIT_REPO=false
if git rev-parse --git-dir > /dev/null 2>&1; then
    IS_GIT_REPO=true
    print_info "Detected git repository"
else
    print_warn "Not a git repository. Skipping git submodule initialization."
    print_warn "If submodules are needed, please clone the repository using: git clone --recursive <repo-url>"
fi

# Function to check if a package is installed
is_package_installed() {
    dpkg -l | grep -q "^ii.*$1 " 2>/dev/null
}

# Function to install packages only if not already installed
install_packages_if_missing() {
    local packages_to_install=()
    for package in "$@"; do
        if is_package_installed "$package"; then
            print_info "Package $package is already installed, skipping..."
        else
            packages_to_install+=("$package")
        fi
    done
    
    if [ ${#packages_to_install[@]} -gt 0 ]; then
        print_info "Installing missing packages: ${packages_to_install[*]}..."
        sudo apt-get install -y "${packages_to_install[@]}"
    else
        print_info "All required packages are already installed."
    fi
}

# Update package list (only if apt-get is available)
if command -v apt-get &> /dev/null; then
    print_info "Updating package list..."
    sudo apt-get update -qq
    
    # Install basic dependencies (only if missing)
    print_info "Checking basic build dependencies..."
    install_packages_if_missing \
        build-essential \
        curl \
        git \
        pkg-config \
        libssl-dev \
        ca-certificates \
        gnupg \
        lsb-release
else
    print_warn "apt-get not available. Skipping system package installation."
    print_warn "Please ensure the following are installed: build-essential, curl, git, pkg-config, libssl-dev, ca-certificates, gnupg, lsb-release"
fi

# Check and install Rust 1.82.0
print_info "Checking Rust installation..."
RUST_REQUIRED_VERSION="1.82.0"
RUST_INSTALL_NEEDED=false

if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version | awk '{print $2}')
    print_info "Rust is already installed: $RUST_VERSION"
    
    # Check if version is 1.82.0 or compatible
    # Extract major.minor version
    RUST_MAJOR=$(echo "$RUST_VERSION" | cut -d. -f1)
    RUST_MINOR=$(echo "$RUST_VERSION" | cut -d. -f2)
    
    if [ "$RUST_MAJOR" -gt 1 ] || ([ "$RUST_MAJOR" -eq 1 ] && [ "$RUST_MINOR" -ge 82 ]); then
        print_info "Rust version $RUST_VERSION is compatible (>= 1.82.0), skipping installation"
    else
        print_warn "Rust version $RUST_VERSION is older than required 1.82.0"
        RUST_INSTALL_NEEDED=true
    fi
else
    print_info "Rust is not installed."
    RUST_INSTALL_NEEDED=true
fi

if [ "$RUST_INSTALL_NEEDED" = true ]; then
    print_info "Installing Rust $RUST_REQUIRED_VERSION via rustup..."
    
    # Check if rustup is already installed
    if ! command -v rustup &> /dev/null; then
        print_info "Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        MADE_CARGO_CHANGES=true
    else
        print_info "rustup is already installed: $(rustup --version)"
    fi
    
    # Always source cargo env to ensure rustc and cargo are in PATH
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
        MADE_CARGO_CHANGES=true
        
        # Persist cargo env sourcing to shell config files
        if add_cargo_env_to_shell_config "$HOME/.bashrc"; then
            print_info "Added Rust/Cargo environment to ~/.bashrc"
        fi
        if [ -f "$HOME/.profile" ] && add_cargo_env_to_shell_config "$HOME/.profile"; then
            print_info "Added Rust/Cargo environment to ~/.profile"
            MADE_PROFILE_CHANGES=true
        fi
    fi
    
    # Check if the specific version is already installed
    if rustup toolchain list | grep -q "^$RUST_REQUIRED_VERSION"; then
        print_info "Rust $RUST_REQUIRED_VERSION is already installed via rustup, setting as default..."
        rustup default "$RUST_REQUIRED_VERSION"
    else
        print_info "Installing Rust $RUST_REQUIRED_VERSION..."
        rustup install "$RUST_REQUIRED_VERSION"
        rustup default "$RUST_REQUIRED_VERSION"
    fi
else
    # Even if Rust is already installed, make sure cargo env is sourced if it exists
    # This handles the case where rustc is in PATH but cargo env hasn't been sourced
    if [ -f "$HOME/.cargo/env" ]; then
        if ! command -v rustc &> /dev/null; then
            source "$HOME/.cargo/env"
        fi
        
        # Always ensure cargo env is in shell config files for persistence
        if add_cargo_env_to_shell_config "$HOME/.bashrc"; then
            print_info "Added Rust/Cargo environment to ~/.bashrc"
            MADE_CARGO_CHANGES=true
        fi
        if [ -f "$HOME/.profile" ] && add_cargo_env_to_shell_config "$HOME/.profile"; then
            print_info "Added Rust/Cargo environment to ~/.profile"
            MADE_PROFILE_CHANGES=true
        fi
    fi
fi

# Verify Rust installation
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version)
    print_info "Rust version: $RUST_VERSION"
    CARGO_VERSION=$(cargo --version)
    print_info "Cargo version: $CARGO_VERSION"
else
    print_warn "rustc not found in PATH. You may need to run: source ~/.cargo/env"
fi

# Function to check if Go is installed at a specific path with a specific version
check_go_version_at_path() {
    local go_path="$1"
    local required_version="$2"
    
    if [ -f "$go_path/bin/go" ]; then
        local installed_version=$("$go_path/bin/go" version | awk '{print $3}' | sed 's/go//')
        local installed_major=$(echo "$installed_version" | cut -d. -f1)
        local installed_minor=$(echo "$installed_version" | cut -d. -f2)
        local required_major=$(echo "$required_version" | cut -d. -f1)
        local required_minor=$(echo "$required_version" | cut -d. -f2)
        
        if [ "$installed_major" -gt "$required_major" ] || \
           ([ "$installed_major" -eq "$required_major" ] && [ "$installed_minor" -ge "$required_minor" ]); then
            echo "$installed_version"
            return 0
        fi
    fi
    return 1
}

# Function to install Go 1.19
install_go_1_19() {
    GO_VERSION="1.19.13"
    GO_ARCH="linux-amd64"
    GO_TAR="go${GO_VERSION}.${GO_ARCH}.tar.gz"
    GO_URL="https://go.dev/dl/${GO_TAR}"
    
    # Check if the exact version is already installed at /usr/local/go
    if check_go_version_at_path "/usr/local/go" "1.19" > /dev/null; then
        INSTALLED_VERSION=$(check_go_version_at_path "/usr/local/go" "1.19")
        print_info "Go $INSTALLED_VERSION is already installed at /usr/local/go, skipping installation"
        return 0
    fi
    
    # Remove existing Go installation if in /usr/local/go (and version is incompatible)
    if [ -d "/usr/local/go" ]; then
        print_info "Removing existing Go installation at /usr/local/go (version incompatible)..."
        sudo rm -rf /usr/local/go
    fi
    
    # Check if the tarball already exists in /tmp
    cd /tmp || exit 1
    if [ -f "$GO_TAR" ]; then
        print_info "Go tarball $GO_TAR already exists in /tmp, skipping download..."
    else
        # Download and install Go
        print_info "Downloading Go ${GO_VERSION}..."
        curl -LO "$GO_URL"
    fi
    
    print_info "Installing Go ${GO_VERSION}..."
    sudo tar -C /usr/local -xzf "$GO_TAR"
    rm -f "$GO_TAR"
    
    # Return to original directory
    cd "$ORIGINAL_DIR" || exit 1
    
    # Add Go to PATH in shell config files if not already there
    if add_go_to_path_in_shell_config "$HOME/.bashrc"; then
        print_info "Added Go to PATH in ~/.bashrc"
        MADE_BASHRC_CHANGES=true
    fi
    if [ -f "$HOME/.profile" ] && add_go_to_path_in_shell_config "$HOME/.profile"; then
        print_info "Added Go to PATH in ~/.profile"
        MADE_PROFILE_CHANGES=true
    fi
    
    # Also add to current session
    export PATH=$PATH:/usr/local/go/bin
}

# Check and install Go 1.19
print_info "Checking Go installation..."
GO_INSTALL_NEEDED=false
GO_REQUIRED_VERSION="1.19"

if command -v go &> /dev/null; then
    GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    print_info "Go is already installed: $GO_VERSION"
    
    # Check if version is 1.19 or compatible
    GO_MAJOR=$(echo "$GO_VERSION" | cut -d. -f1)
    GO_MINOR=$(echo "$GO_VERSION" | cut -d. -f2)
    
    if [ "$GO_MAJOR" -gt 1 ] || ([ "$GO_MAJOR" -eq 1 ] && [ "$GO_MINOR" -ge 19 ]); then
        print_info "Go version $GO_VERSION is compatible (>= 1.19), skipping installation"
    else
        print_warn "Go version $GO_VERSION is older than required 1.19"
        GO_INSTALL_NEEDED=true
    fi
else
    print_info "Go is not installed in PATH."
    # Check if it's installed at /usr/local/go but not in PATH
    if check_go_version_at_path "/usr/local/go" "$GO_REQUIRED_VERSION" > /dev/null; then
        INSTALLED_VERSION=$(check_go_version_at_path "/usr/local/go" "$GO_REQUIRED_VERSION")
        print_info "Go $INSTALLED_VERSION is installed at /usr/local/go but not in PATH"
        print_info "Adding /usr/local/go/bin to PATH..."
        if add_go_to_path_in_shell_config "$HOME/.bashrc"; then
            print_info "Added Go to PATH in ~/.bashrc"
            MADE_BASHRC_CHANGES=true
        fi
        if [ -f "$HOME/.profile" ] && add_go_to_path_in_shell_config "$HOME/.profile"; then
            print_info "Added Go to PATH in ~/.profile"
            MADE_PROFILE_CHANGES=true
        fi
        # Add to current session PATH
        export PATH=$PATH:/usr/local/go/bin
    else
        GO_INSTALL_NEEDED=true
    fi
fi

if [ "$GO_INSTALL_NEEDED" = true ]; then
    print_info "Installing Go 1.19..."
    install_go_1_19
fi

# Verify Go installation
if command -v go &> /dev/null; then
    GO_VERSION=$(go version)
    print_info "Go version: $GO_VERSION"
else
    print_warn "go not found in PATH. You may need to run: export PATH=\$PATH:/usr/local/go/bin"
    print_warn "Or restart your terminal to load changes from ~/.bashrc"
fi

# Ensure we're in the original directory
cd "$ORIGINAL_DIR" || exit 1

# Setup git submodules (only if this is a git repository)
if [ "$IS_GIT_REPO" = true ]; then
    # Check if submodules are already initialized and populated
    SUBMODULES_NEED_INIT=false
    if [ -f ".gitmodules" ]; then
        # Check if any submodules are not initialized or are empty
        while IFS= read -r line; do
            SUBMODULE_PATH=$(echo "$line" | awk '{print $2}')
            if [ -n "$SUBMODULE_PATH" ]; then
                # Check if directory exists and has content
                if [ ! -d "$SUBMODULE_PATH" ] || [ ! -d "$SUBMODULE_PATH/.git" ]; then
                    SUBMODULES_NEED_INIT=true
                    break
                else
                    # Check if directory is empty (has no files except .git)
                    FILE_COUNT=$(find "$SUBMODULE_PATH" -mindepth 1 -maxdepth 1 ! -name '.git' 2>/dev/null | wc -l)
                    if [ "$FILE_COUNT" -eq 0 ]; then
                        print_info "Submodule $SUBMODULE_PATH exists but is empty, will reinitialize..."
                        SUBMODULES_NEED_INIT=true
                        break
                    fi
                fi
            fi
        done < <(git config --file .gitmodules --get-regexp path | awk '{print $2}')
        
        if [ "$SUBMODULES_NEED_INIT" = false ]; then
            print_info "Git submodules appear to be already initialized"
        fi
    fi
    
    if [ "$SUBMODULES_NEED_INIT" = true ] || ! git submodule status > /dev/null 2>&1; then
        print_info "Initializing and updating git submodules..."
        # Remove empty submodule directories before initialization
        if [ -f ".gitmodules" ]; then
            while IFS= read -r line; do
                SUBMODULE_PATH=$(echo "$line" | awk '{print $2}')
                if [ -n "$SUBMODULE_PATH" ] && [ -d "$SUBMODULE_PATH" ] && [ ! -d "$SUBMODULE_PATH/.git" ]; then
                    print_info "Removing empty submodule directory: $SUBMODULE_PATH"
                    rm -rf "$SUBMODULE_PATH"
                fi
            done < <(git config --file .gitmodules --get-regexp path | awk '{print $2}')
        fi
        # Sync submodule URLs first
        git submodule sync --recursive 2>/dev/null || true
        # Force initialization and update
        if git submodule update --init --recursive; then
            print_info "Git submodules initialized successfully"
        else
            print_warn "Failed to initialize git submodules. Trying alternative method..."
            # Alternative: initialize each submodule individually
            if [ -f ".gitmodules" ]; then
                while IFS= read -r line; do
                    SUBMODULE_PATH=$(echo "$line" | awk '{print $2}')
                    if [ -n "$SUBMODULE_PATH" ]; then
                        print_info "Initializing submodule: $SUBMODULE_PATH"
                        # Remove empty directory if it exists
                        if [ -d "$SUBMODULE_PATH" ] && [ ! -d "$SUBMODULE_PATH/.git" ]; then
                            print_info "Removing empty submodule directory: $SUBMODULE_PATH"
                            rm -rf "$SUBMODULE_PATH"
                        fi
                        git submodule update --init --recursive "$SUBMODULE_PATH" || true
                    fi
                done < <(git config --file .gitmodules --get-regexp path | awk '{print $2}')
            fi
        fi
    else
        print_info "Updating git submodules to latest commits..."
        git submodule sync --recursive 2>/dev/null || true
        git submodule update --recursive --remote 2>/dev/null || true
    fi
    
    # Verify submodules are initialized and populated
    print_info "Verifying submodules..."
    if git submodule status > /dev/null 2>&1; then
        git submodule status
        # Double-check that submodules have content
        if [ -f ".gitmodules" ]; then
            while IFS= read -r line; do
                SUBMODULE_PATH=$(echo "$line" | awk '{print $2}')
                if [ -n "$SUBMODULE_PATH" ] && [ -d "$SUBMODULE_PATH" ]; then
                    FILE_COUNT=$(find "$SUBMODULE_PATH" -mindepth 1 -maxdepth 1 ! -name '.git' 2>/dev/null | wc -l)
                    if [ "$FILE_COUNT" -eq 0 ]; then
                        print_warn "Warning: Submodule $SUBMODULE_PATH is still empty after initialization"
                        print_warn "You may need to manually run: git submodule update --init --recursive --force"
                    fi
                fi
            done < <(git config --file .gitmodules --get-regexp path | awk '{print $2}')
        fi
    else
        print_warn "Could not verify submodule status"
    fi
else
    print_info "Skipping git submodule initialization (not a git repository)"
fi

# Ensure we're still in the original directory before fetching dependencies
cd "$ORIGINAL_DIR" || exit 1

# Download Rust dependencies (optional, but helpful to verify)
print_info "Checking Rust dependencies..."
if [ -f "ark-iesp/Cargo.toml" ]; then
    if [ -f "ark-iesp/Cargo.lock" ]; then
        print_info "Cargo.lock exists for ark-iesp, dependencies may already be downloaded"
        print_info "Verifying/updating dependencies for ark-iesp..."
    else
        print_info "Fetching dependencies for ark-iesp..."
    fi
    cd ark-iesp || exit 1
    cargo fetch
    cd "$ORIGINAL_DIR" || exit 1
fi

if [ -f "halo2/Cargo.toml" ]; then
    if [ -f "halo2/Cargo.lock" ]; then
        print_info "Cargo.lock exists for halo2, dependencies may already be downloaded"
        print_info "Verifying/updating dependencies for halo2..."
    else
        print_info "Fetching dependencies for halo2..."
    fi
    cd halo2 || exit 1
    cargo fetch
    cd "$ORIGINAL_DIR" || exit 1
fi

if [ -f "halo2-link-circuit/Cargo.toml" ]; then
    if [ -f "halo2-link-circuit/Cargo.lock" ]; then
        print_info "Cargo.lock exists for halo2-link-circuit, dependencies may already be downloaded"
        print_info "Verifying/updating dependencies for halo2-link-circuit..."
    else
        print_info "Fetching dependencies for halo2-link-circuit..."
    fi
    cd halo2-link-circuit || exit 1
    cargo fetch
    cd "$ORIGINAL_DIR" || exit 1
fi

# Download Go dependencies (optional, but helpful to verify)
print_info "Checking Go dependencies..."
if [ -f "rsa_accumulator/go.mod" ]; then
    if [ -f "rsa_accumulator/go.sum" ]; then
        print_info "go.sum exists for rsa_accumulator, dependencies may already be downloaded"
        print_info "Verifying/updating dependencies for rsa_accumulator..."
    else
        print_info "Downloading dependencies for rsa_accumulator..."
    fi
    cd rsa_accumulator || exit 1
    go mod download
    cd "$ORIGINAL_DIR" || exit 1
fi

if [ -f "VTLP/go.mod" ]; then
    if [ -f "VTLP/go.sum" ]; then
        print_info "go.sum exists for VTLP, dependencies may already be downloaded"
        print_info "Verifying/updating dependencies for VTLP..."
    else
        print_info "Downloading dependencies for VTLP..."
    fi
    cd VTLP || exit 1
    go mod download
    cd "$ORIGINAL_DIR" || exit 1
fi

print_info ""
print_info "=========================================="
print_info "Setup completed successfully!"
print_info "=========================================="
print_info ""

# Check what's available in PATH
print_info "Installed versions (in this script's environment):"
if command -v rustc &> /dev/null; then
    print_info "  Rust: $(rustc --version)"
    print_info "  Cargo: $(cargo --version)"
else
    print_warn "  Rust: Not in PATH (but may be installed)"
fi

if command -v go &> /dev/null; then
    print_info "  Go: $(go version)"
else
    print_warn "  Go: Not in PATH (but may be installed)"
fi
print_info ""

if [ "$IS_GIT_REPO" = true ]; then
    print_info "Git submodules status:"
    if git submodule status > /dev/null 2>&1; then
        git submodule status
    else
        print_warn "Could not check submodule status"
    fi
else
    print_info "Git submodules: Skipped (not a git repository)"
fi
print_info ""

# Always show instructions if we made changes that require sourcing
if [ "$MADE_CARGO_CHANGES" = true ] || [ "$MADE_BASHRC_CHANGES" = true ] || [ "$MADE_PROFILE_CHANGES" = true ]; then
    print_warn "=========================================="
    print_warn "IMPORTANT: Environment changes were made!"
    print_warn "=========================================="
    print_warn "To use Rust and/or Go in your CURRENT shell, run:"
    print_warn ""
    if [ "$MADE_CARGO_CHANGES" = true ]; then
        print_warn "  source ~/.cargo/env  # For Rust"
    fi
    if [ "$MADE_BASHRC_CHANGES" = true ] || [ "$MADE_PROFILE_CHANGES" = true ]; then
        print_warn "  export PATH=\$PATH:/usr/local/go/bin  # For Go"
    fi
    print_warn ""
    CONFIG_FILES=""
    if [ "$MADE_BASHRC_CHANGES" = true ]; then
        CONFIG_FILES="~/.bashrc"
    fi
    if [ "$MADE_PROFILE_CHANGES" = true ]; then
        if [ -n "$CONFIG_FILES" ]; then
            CONFIG_FILES="$CONFIG_FILES and ~/.profile"
        else
            CONFIG_FILES="~/.profile"
        fi
    fi
    if [ -n "$CONFIG_FILES" ]; then
        print_warn "Or simply restart your terminal to load changes from $CONFIG_FILES"
    else
        print_warn "Or simply restart your terminal to load changes"
    fi
    print_warn "=========================================="
    print_info ""
fi

print_info "You can now build the projects:"
print_info "  Rust projects: cd <project> && cargo update && cargo build --release"
print_info "  Go projects: cd <project> && go build"
print_info ""
print_info "Note: For Rust benchmarks, run 'cargo update' first before building."
print_info ""
print_warn "=========================================="
print_warn "IMPORTANT: Reload your shell environment!"
print_warn "=========================================="
print_warn "Run the following command to make Rust and Go available:"
print_warn ""
print_warn "  source ~/.bashrc"
print_warn ""
print_warn "Or simply restart your terminal."
print_warn "=========================================="
print_info ""


