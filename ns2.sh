#!/bin/bash

# === Step 1: Dependencies Check ===
if ! command -v xauth &> /dev/null; then
    echo "Error: 'xauth' is not installed. Please install it (e.g., sudo apt install xauth)."
    exit 1
fi

# === Step 2: Build Docker image ===
echo "Building ns-2 Docker image..."
docker build -f Dockerfile.ns2 -t ns2-gui .

# === Step 3: Set up Universal X11 Permissions ===
# We create a temporary xauth file that allows the container to communicate 
# with the host's display server, regardless of Xorg or Xwayland.
XAUTH=/tmp/.docker.xauth
touch "$XAUTH"
# This magic line extracts the local X11 cookie and formats it for the container
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
chmod 644 "$XAUTH"

# === Step 4: Detect Display Environment (Informational) ===
if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "Environment: Xwayland detected."
else
    echo "Environment: Xorg detected."
    # xhost is still helpful as a fallback for pure Xorg systems
    xhost +local:docker > /dev/null
fi

# === Step 5: Prepare code directory ===
CODE_DIR="$(pwd)/code"
mkdir -p "$CODE_DIR"

# === Step 6: Run ns-2 container ===
echo "Starting ns-2 container..."
docker run -it --rm \
    --net=host \
    -e DISPLAY="$DISPLAY" \
    -e XAUTHORITY="$XAUTH" \
    -v "$XAUTH":"$XAUTH" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$CODE_DIR":/opt/ns2/code \
    ns2-gui