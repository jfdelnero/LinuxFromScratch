#!/data/data/com.termux/files/usr/bin/bash

# Check if running in Termux
if [ -z "$TERMUX_VERSION" ]; then
    echo "This script is intended for Termux environment."
    exit 1
fi

echo "Setting up Termux build environment..."

# Check if proot-distro is installed
if ! command -v proot-distro &> /dev/null; then
    echo "Installing proot-distro..."
    pkg install -y proot-distro
fi

# Install debian if not already installed
# proot-distro install checks if it is installed, so we can just run it.
# However, to avoid redownloading/checking every time if it takes long, we can check.
if ! proot-distro list | grep -q "debian (installed)"; then
    echo "Installing Debian..."
    proot-distro install debian
else
    echo "Debian is already installed."
fi

# Determine repo directory
REPO_DIR=$(pwd)
SCRIPT_PATH="/root/LinuxFromScratch/scripts/setup_proot_env.sh"

echo "Installing dependencies inside PRoot environment..."
# We bind mount the current directory to /root/LinuxFromScratch
# Run the setup script using bash explicitly
proot-distro login debian --bind "$REPO_DIR:/root/LinuxFromScratch" -- bash "$SCRIPT_PATH"

echo "Setup complete."
echo "To enter the build environment, run:"
echo "proot-distro login debian --bind \"$REPO_DIR:/root/LinuxFromScratch\" --cwd /root/LinuxFromScratch"
echo ""
echo "Then inside the environment:"
echo "./set_env.sh <target>"
echo "sysbuild.sh"
