#!/bin/bash

# === Step 1: Dependencies Check ===
if ! command -v xauth &> /dev/null; then
    echo "Error: 'xauth' is not installed. Please install it (e.g., sudo apt install xauth)."
    exit 1
fi

if [ -z "$DISPLAY" ]; then
    echo "Error: No DISPLAY detected. If you are on a headless server, use Xvfb or SSH with X11 forwarding."
    exit 1
fi

# === Step 2: Build Docker image ===
echo "Building ns-3 Docker image..."
docker build -f Dockerfile.ns3 -t ns3-gui .

# === Step 3: Set up Universal X11 Permissions ===
# Create a temporary xauth file to bridge the host and container display protocols
XAUTH=/tmp/.docker.xauth.ns3
touch "$XAUTH"
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
chmod 644 "$XAUTH"

# === Step 4: Environment Detection ===
if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "Detected Environment: Xwayland"
else
    echo "Detected Environment: Xorg"
    xhost +local:docker > /dev/null
fi

# === Step 5: Prepare code directory ===
CODE_DIR="$(pwd)/code"
mkdir -p "$CODE_DIR"

# === Step 6: Run ns-3 container ===
echo "Starting ns-3 container..."
docker run -it --rm \
    --net=host \
    -e DISPLAY="$DISPLAY" \
    -e XAUTHORITY="$XAUTH" \
    -v "$XAUTH":"$XAUTH" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$CODE_DIR":/opt/ns3/code \
    ns3-gui