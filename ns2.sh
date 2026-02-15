#!/bin/bash

# === Step 1: Build Docker image ===
echo "Building ns-2 Docker image..."
docker build -f Dockerfile.ns2 -t ns2-gui .

# === Step 2: Check for X server ===
if pgrep -x "Xorg" > /dev/null || pgrep -x "X" > /dev/null; then
    echo "X server is running."
else
    echo "No X server detected. Please start your desktop environment or X server manually."
    exit 1
fi

# === Step 3: Prepare code directory ===
CODE_DIR="$(pwd)/code"
if [ ! -d "$CODE_DIR" ]; then
    echo "Creating code directory..."
    mkdir "$CODE_DIR"
fi

# === Step 4: Run ns-2 container with mounted code/ directory ===
echo "Running ns-2 container..."
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -v "$CODE_DIR":/opt/ns2/code \
    ns2-gui
