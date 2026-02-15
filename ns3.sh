#!/bin/bash

# === Step 1: Build Docker image ===
echo "Building ns-3 Docker image..."
docker build -f Dockerfile.ns3 -t ns3-gui .

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

# === Step 4: Run ns-3 container with mounted code/ directory ===
echo "Running ns-3 container..."
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -v "$CODE_DIR":/opt/ns3/code \
    ns3-gui
