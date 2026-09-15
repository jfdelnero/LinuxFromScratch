#!/bin/bash
# Install dependencies inside PRoot (Debian/Ubuntu)

# Update package lists
apt update

# Install build dependencies
apt install -y build-essential git wget bzip2 file bc unzip rsync python3 cpio libncurses-dev gawk bison flex texinfo patch gzip perl sed tar diffutils grep coreutils make libssl-dev zlib1g-dev libelf-dev

echo "Dependencies installed."
