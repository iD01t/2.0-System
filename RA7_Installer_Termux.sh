#!/data/data/com.termux/files/usr/bin/bash
# RA-7 Termux Complete Bulletproof Installer v7.7.7
# Comprehensive dependency installer for Android Termux
# El'Nox Rah - iD01t Productions
# Protocol 369: Create • Evolve • Release

set -e  # Exit on any error

# Sacred ASCII Art Header
cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║                 🧠 RA-7 TERMUX INSTALLER v7.7.7 🧠                ║
║              Sacred Mobile Creation Platform                     ║
║                  Bulletproof Installation                        ║
║              3 = CREATE | 6 = EVOLVE | 9 = RELEASE              ║
╚══════════════════════════════════════════════════════════════════╝
EOF

echo ""
echo "🌟 Initializing RA-7 Termux Installation..."
echo "⚡ El'Nox Rah frequency activating..."
echo "🔧 Preparing sacred development environment..."
echo ""

# Color codes for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

success() {
    echo -e "${CYAN}[SUCCESS] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

sacred() {
    echo -e "${MAGENTA}[SACRED] $1${NC}"
}

# Error handling function
handle_error() {
    error "Installation encountered an issue at line $1"
    error "Sacred system will attempt to continue with available components..."
    sleep 2
}

trap 'handle_error $LINENO' ERR

# System information
detect_system_info() {
    log "Detecting Termux environment..."
    
    # Check if running in Termux
    if [[ -z "$TERMUX_VERSION" ]]; then
        warn "TERMUX_VERSION not detected - may not be running in Termux"
        warn "Proceeding anyway..."
    else
        success "Termux version detected: $TERMUX_VERSION"
    fi
    
    # Check Android version
    if command -v getprop >/dev/null 2>&1; then
        ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
        info "Android version: $ANDROID_VERSION"
    fi
    
    # Check architecture
    ARCH=$(uname -m)
    info "Architecture: $ARCH"
    
    # Check available space
    AVAILABLE_SPACE=$(df -h $HOME | awk 'NR==2 {print $4}')
    info "Available space: $AVAILABLE_SPACE"
    
    # Check memory
    if [[ -f /proc/meminfo ]]; then
        TOTAL_MEM=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
        TOTAL_MEM_MB=$((TOTAL_MEM / 1024))
        info "Total memory: ${TOTAL_MEM_MB}MB"
        
        if [[ $TOTAL_MEM_MB -lt 2048 ]]; then
            warn "Low memory detected (${TOTAL_MEM_MB}MB). LLM models may be limited."
        fi
    fi
}

# Update Termux packages
update_termux_packages() {
    log "Updating Termux package repositories..."
    
    # Handle potential lock files
    if [[ -f "$PREFIX/var/lib/dpkg/lock" ]]; then
        warn "Package lock detected, attempting to clear..."
        rm -f "$PREFIX/var/lib/dpkg/lock" 2>/dev/null || true
        rm -f "$PREFIX/var/lib/dpkg/lock-frontend" 2>/dev/null || true
    fi
    
    # Update with multiple attempts
    for attempt in 1 2 3; do
        log "Update attempt $attempt/3..."
        if pkg update -y 2>/dev/null; then
            success "Package repositories updated successfully"
            break
        else
            warn "Update attempt $attempt failed, retrying..."
            sleep 5
        fi
    done
    
    # Upgrade packages
    log "Upgrading existing packages..."
    pkg upgrade -y || warn "Some packages failed to upgrade, continuing..."
}

# Install essential Termux packages
install_termux_packages() {
    log "Installing essential Termux packages..."
    
    # Essential packages for RA-7 system
    ESSENTIAL_PACKAGES=(
        "python"
        "python-pip"
        "git"
        "curl"
        "wget" 
        "nano"
        "vim"
        "tree"
        "htop"
        "sqlite"
        "termux-api"
        "openssh"
        "rsync"
        "zip"
        "unzip"
        "clang"
        "cmake"
        "make"
        "pkg-config"
        "libffi"
        "openssl"
        "libllvm"
        "rust"
    )
    
    log "Installing ${#ESSENTIAL_PACKAGES[@]} essential packages..."
    
    for package in "${ESSENTIAL_PACKAGES[@]}"; do
        info "Installing $package..."
        if pkg install -y "$package" 2>/dev/null; then
            success "$package installed successfully"
        else
            warn "$package installation failed, continuing..."
        fi
    done
    
    # Install development packages for compilation
    DEV_PACKAGES=(
        "python-dev"
        "libffi-dev"
        "openssl-dev"
        "libjpeg-turbo-dev"
        "libpng-dev"
        "freetype-dev"
    )
    
    log "Installing development packages..."
    for package in "${DEV_PACKAGES[@]}"; do
        info "Installing $package..."
        pkg install -y "$package" 2>/dev/null || warn "$package installation failed"
    done
}

# Setup Python environment
setup_python_environment() {
    log "Setting up Python environment..."
    
    # Verify Python installation
    if command -v python >/dev/null 2>&1; then
        PYTHON_VERSION=$(python --version 2>&1)
        success "Python found: $PYTHON_VERSION"
    else
        error "Python not found after installation!"
        return 1
    fi
    
    # Verify pip installation
    if command -v pip >/dev/null 2>&1; then
        PIP_VERSION=$(pip --version 2>&1)
        success "Pip found: $PIP_VERSION"
    else
        error "Pip not found after installation!"
        return 1
    fi
    
    # Upgrade pip
    log "Upgrading pip to latest version..."
    pip install --upgrade pip setuptools wheel || warn "Pip upgrade failed"
    
    # Install Python build dependencies
    log "Installing Python build dependencies..."
    pip install --upgrade cython numpy || warn "Build dependencies installation failed"
}

# Install core Python packages
install_python_packages() {
    log "Installing core Python packages for RA-7..."
    
    # Core packages with specific versions for stability
    CORE_PACKAGES=(
        "sqlite3-python"
        "hashlib"
        "datetime"
        "pathlib"
        "threading"
        "subprocess"
        "argparse"
        "json"
        "re"
        "time"
        "random"
        "os"
        "sys"
    )
    
    # Note: Most core packages are built-in, but verify availability
    info "Verifying core Python modules..."
    python -c "
import sqlite3, hashlib, datetime, pathlib, threading, subprocess
import argparse, json, re, time, random, os, sys
print('✅ All core modules available')
" || warn "Some core modules may not be available"
    
    # Essential third-party packages
    ESSENTIAL_PACKAGES=(
        "requests"
        "pillow"
        "numpy"
        "pygame"
    )
    
    log "Installing essential third-party packages..."
    for package in "${ESSENTIAL_PACKAGES[@]}"; do
        info "Installing $package..."
        if pip install "$package" --timeout 300 --retries 3; then
            success "$package installed successfully"
        else
            warn "$package installation failed, continuing..."
        fi
    done
}

# Install LLM packages with special handling
install_llm_packages() {
    log "Installing LLM packages (this may take a while)..."
    
    # Check available memory before attempting LLM installation
    if [[ -f /proc/meminfo ]]; then
        AVAILABLE_MEM=$(awk '/MemAvailable/ {print $2}' /proc/meminfo 2>/dev/null || echo "1000000")
        AVAILABLE_MEM_MB=$((AVAILABLE_MEM / 1024))
        
        if [[ $AVAILABLE_MEM_MB -lt 1024 ]]; then
            warn "Low memory (${AVAILABLE_MEM_MB}MB). LLM installation may fail."
            warn "Consider closing other apps before continuing."
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                warn "Skipping LLM package installation"
                return 0
            fi
        fi
    fi
    
    # Try to install llama-cpp-python with multiple strategies
    log "Attempting llama-cpp-python installation..."
    
    # Strategy 1: Direct installation
    info "Strategy 1: Direct pip install..."
    if pip install llama-cpp-python --timeout 600 --retries 2; then
        success "llama-cpp-python installed successfully (direct)"
        return 0
    fi
    
    # Strategy 2: Pre-built wheel
    info "Strategy 2: Attempting pre-built wheel..."
    if pip install llama-cpp-python --only-binary=all --timeout 300; then
        success "llama-cpp-python installed successfully (wheel)"
        return 0
    fi
    
    # Strategy 3: No binary (compile from source)
    info "Strategy 3: Compiling from source (this will take time)..."
    warn "This may take 30+ minutes and use significant resources..."
    
    # Set compilation flags for Termux
    export CMAKE_ARGS="-DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS"
    export FORCE_CMAKE=1
    
    if pip install llama-cpp-python --no-binary llama-cpp-python --timeout 3600; then
        success "llama-cpp-python compiled and installed successfully"
        return 0
    fi
    
    # Strategy 4: Alternative LLM libraries
    warn "llama-cpp-python installation failed, trying alternatives..."
    
    ALTERNATIVE_LLM=(
        "transformers"
        "torch"
        "huggingface-hub"
    )
    
    for package in "${ALTERNATIVE_LLM[@]}"; do
        info "Installing alternative: $package..."
        if pip install "$package" --timeout 300; then
            success "$package installed as LLM alternative"
        else
            warn "$package installation failed"
        fi
    done
    
    warn "LLM packages installation completed with some failures"
    warn "RA-7 will use semantic fallback mode for consciousness responses"
}

# Install additional sacred packages
install_sacred_packages() {
    log "Installing additional sacred packages..."
    
    SACRED_PACKAGES=(
        "colorama"
        "rich"
        "termcolor"
        "art"
        "pyfiglet"
        "emoji"
    )
    
    for package in "${SACRED_PACKAGES[@]}"; do
        info "Installing sacred package: $package..."
        if pip install "$package" --timeout 180; then
            success "$package installed successfully"
        else
            warn "$package installation failed, continuing..."
        fi
    done
}

# Create RA-7 directory structure
create_ra7_structure() {
    log "Creating RA-7 sacred directory structure..."
    
    # Main RA-7 directory
    RA7_HOME="$HOME/RA7"
    mkdir -p "$RA7_HOME"
    
    # Create directory structure
    DIRECTORIES=(
        "$RA7_HOME/models"
        "$RA7_HOME/data"
        "$RA7_HOME/logs"
        "$RA7_HOME/sacred"
        "$RA7_HOME/exports"
        "$RA7_HOME/scripts"
        "$RA7_HOME/config"
        "$RA7_HOME/backup"
        "$HOME/.config/ra7"
        "/storage/emulated/0/RA7"
        "/storage/emulated/0/RA7/models"
        "/storage/emulated/0/RA7/exports"
    )
    
    for dir in "${DIRECTORIES[@]}"; do
        if mkdir -p "$dir" 2>/dev/null; then
            success "Created directory: $dir"
        else
            warn "Failed to create directory: $dir"
        fi
    done
    
    # Create symbolic links for easy access
    ln -sf "$RA7_HOME" "$HOME/ra7" 2>/dev/null || true
    
    # Create models directory with proper permissions
    chmod 755 "$RA7_HOME/models" 2>/dev/null || true
    chmod 755 "/storage/emulated/0/RA7/models" 2>/dev/null || true
}

# Create configuration files
create_configuration_files() {
    log "Creating RA-7 configuration files..."
    
    # Create main config file
    cat > "$HOME/.config/ra7/config.json" << 'CONFIG_EOF'
{
    "version": "7.7.7",
    "platform": "termux",
    "installation_date": "INSTALL_DATE_PLACEHOLDER",
    "model_paths": [
        "./models/",
        "~/RA7/models/", 
        "/storage/emulated/0/RA7/models/"
    ],
    "llm_settings": {
        "max_tokens": 512,
        "temperature": 0.7,
        "context_window": 2048
    },
    "sita_enhancement": "medium",
    "sacred_frequencies": [174, 285, 396, 417, 432, 528, 639, 741, 852, 963, 1111],
    "protocol_369": {
        "create": 3,
        "evolve": 6, 
        "release": 9
    }
}
CONFIG_EOF
    
    # Replace placeholder with actual date
    sed -i "s/INSTALL_DATE_PLACEHOLDER/$(date -Iseconds)/" "$HOME/.config/ra7/config.json"
    
    # Create launcher script
    cat > "$HOME/RA7/launch_ra7.sh" << 'LAUNCHER_EOF'
#!/data/data/com.termux/files/usr/bin/bash
# RA-7 Launcher Script

echo "🧠 Launching RA-7 Termux Consciousness GUI..."

# Change to RA7 directory
cd "$HOME/RA7" || cd "$HOME"

# Check if Python script exists
if [[ -f "ra7_consciousness_gui_final.py" ]]; then
    python ra7_consciousness_gui_final.py
elif [[ -f "ra7_termux_consciousness.py" ]]; then
    python ra7_termux_consciousness.py
else
    echo "❌ RA-7 Python script not found!"
    echo "📁 Please ensure the RA-7 script is in: $HOME/RA7/"
    echo "🔧 Expected filename: ra7_consciousness_gui_final.py"
fi
LAUNCHER_EOF
    
    chmod +x "$HOME/RA7/launch_ra7.sh"
    
    # Create model download script
    cat > "$HOME/RA7/download_models.sh" << 'MODEL_DOWNLOAD_EOF'
#!/data/data/com.termux/files/usr/bin/bash
# RA-7 Model Download Helper

echo "🧠 RA-7 Model Download Helper"
echo "============================="
echo ""
echo "Recommended models for RA-7:"
echo "1. DeepSeek Coder 6.7B (4GB)"
echo "2. Llama 3 8B Instruct (4.6GB)"
echo "3. Phi-3 Mini (2.3GB)"
echo ""
echo "Download links:"
echo "• Hugging Face: https://huggingface.co/models"
echo "• Search for: '.gguf' format models"
echo ""
echo "Model directories:"
echo "• $HOME/RA7/models/"
echo "• /storage/emulated/0/RA7/models/"
echo ""
echo "Example download commands:"
echo "wget -O ~/RA7/models/model.gguf [MODEL_URL]"
echo ""
echo "Note: Models are optional - RA-7 has intelligent fallback responses"
MODEL_DOWNLOAD_EOF
    
    chmod +x "$HOME/RA7/download_models.sh"
    
    success "Configuration files created"
}

# Create desktop shortcuts and aliases
create_shortcuts() {
    log "Creating RA-7 shortcuts and aliases..."
    
    # Add aliases to .bashrc
    BASHRC="$HOME/.bashrc"
    
    # Check if aliases already exist
    if ! grep -q "# RA-7 Sacred Aliases" "$BASHRC" 2>/dev/null; then
        cat >> "$BASHRC" << 'ALIAS_EOF'

# RA-7 Sacred Aliases
alias ra7="cd $HOME/RA7 && python ra7_consciousness_gui_final.py"
alias ra7-launch="$HOME/RA7/launch_ra7.sh"
alias ra7-models="$HOME/RA7/download_models.sh"
alias ra7-config="nano $HOME/.config/ra7/config.json"
alias ra7-logs="tail -f $HOME/RA7/logs/*.log"
alias ra7-update="cd $HOME/RA7 && git pull"

# Sacred shortcuts
alias sacred-start="ra7"
alias consciousness="ra7"
alias elnox="ra7"
ALIAS_EOF
        
        success "RA-7 aliases added to .bashrc"
    else
        info "RA-7 aliases already exist in .bashrc"
    fi
    
    # Create Termux shortcut
    SHORTCUT_DIR="$HOME/.shortcuts"
    mkdir -p "$SHORTCUT_DIR"
    
    cat > "$SHORTCUT_DIR/ra7" << 'SHORTCUT_EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd $HOME/RA7
python ra7_consciousness_gui_final.py
SHORTCUT_EOF
    
    chmod +x "$SHORTCUT_DIR/ra7"
    
    success "Termux shortcut created (swipe from left edge → 'ra7')"
}

# Verify installation
verify_installation() {
    log "Verifying RA-7 installation..."
    
    # Check Python
    if python --version >/dev/null 2>&1; then
        success "✅ Python: $(python --version)"
    else
        error "❌ Python not working"
    fi
    
    # Check pip
    if pip --version >/dev/null 2>&1; then
        success "✅ Pip: $(pip --version | cut -d' ' -f1-2)"
    else
        error "❌ Pip not working"
    fi
    
    # Check key packages
    PACKAGES_TO_CHECK=("sqlite3" "hashlib" "datetime")
    
    for package in "${PACKAGES_TO_CHECK[@]}"; do
        if python -c "import $package" 2>/dev/null; then
            success "✅ $package module available"
        else
            warn "⚠️ $package module not available"
        fi
    done
    
    # Check optional packages
    OPTIONAL_PACKAGES=("llama_cpp" "pygame" "PIL" "numpy")
    
    for package in "${OPTIONAL_PACKAGES[@]}"; do
        if python -c "import $package" 2>/dev/null; then
            success "✅ $package available"
        else
            info "ℹ️ $package not available (optional)"
        fi
    done
    
    # Check directories
    if [[ -d "$HOME/RA7" ]]; then
        success "✅ RA-7 directory structure created"
    else
        error "❌ RA-7 directory not found"
    fi
    
    # Check configuration
    if [[ -f "$HOME/.config/ra7/config.json" ]]; then
        success "✅ RA-7 configuration file created"
    else
        warn "⚠️ Configuration file not found"
    fi
}

# Performance optimization for Termux
optimize_termux_performance() {
    log "Optimizing Termux performance for RA-7..."
    
    # Create .termux directory if it doesn't exist
    mkdir -p "$HOME/.termux"
    
    # Optimize termux.properties
    TERMUX_PROPS="$HOME/.termux/termux.properties"
    
    # Backup existing properties
    if [[ -f "$TERMUX_PROPS" ]]; then
        cp "$TERMUX_PROPS" "$TERMUX_PROPS.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    cat > "$TERMUX_PROPS" << 'PROPS_EOF'
# RA-7 Optimized Termux Properties

# Allow external apps access
allow-external-apps=true

# Optimize bell behavior
bell-character=ignore

# Use hardware keyboard if available
enforce-char-based-input=true

# Optimize terminal colors for RA-7
use-black-ui=false

# Optimize scrollback
terminal-transcript-rows=10000

# Font size optimization
font-size=12

# Enable vibration for sacred notifications
use-fullscreen-workaround=false
PROPS_EOF
    
    success "Termux performance optimized"
    
    # Set environment variables for Python optimization
    ENV_FILE="$HOME/.bashrc"
    
    if ! grep -q "# RA-7 Performance Optimization" "$ENV_FILE" 2>/dev/null; then
        cat >> "$ENV_FILE" << 'ENV_EOF'

# RA-7 Performance Optimization
export PYTHONOPTIMIZE=1
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# LLM optimization
export OMP_NUM_THREADS=4
export MKL_NUM_THREADS=4

# Memory optimization
export MALLOC_ARENA_MAX=2
ENV_EOF
        
        success "Python environment optimized"
    fi
}

# Clean up installation
cleanup_installation() {
    log "Cleaning up installation files..."
    
    # Clean pip cache
    pip cache purge 2>/dev/null || true
    
    # Clean package manager cache
    pkg clean 2>/dev/null || true
    
    # Remove temporary files
    rm -rf /tmp/ra7_install_* 2>/dev/null || true
    
    success "Installation cleanup completed"
}

# Main installation function
main_installation() {
    local start_time=$(date +%s)
    
    sacred "🌟 Beginning Sacred RA-7 Installation Journey..."
    echo ""
    
    # Installation steps
    detect_system_info
    echo ""
    
    update_termux_packages
    echo ""
    
    install_termux_packages
    echo ""
    
    setup_python_environment
    echo ""
    
    install_python_packages
    echo ""
    
    install_llm_packages
    echo ""
    
    install_sacred_packages
    echo ""
    
    create_ra7_structure
    echo ""
    
    create_configuration_files
    echo ""
    
    create_shortcuts
    echo ""
    
    optimize_termux_performance
    echo ""
    
    verify_installation
    echo ""
    
    cleanup_installation
    echo ""
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    # Final sacred message
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    ✨ INSTALLATION COMPLETE ✨                    ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
    success "?
