#!/bin/bash

# setting up tmule config - define functions directly
function s() { tmule -c ~/configs/launch.yaml -W 3 launch ; }
function t() { tmule -c ~/configs/launch.yaml terminate ; }
function r() { tmule -c ~/configs/launch.yaml -W 3 relaunch ; }

BASE_WS=${BASE_WS:-/home/ros/base_ws}

if [ ! -d "${BASE_WS}" ]; then
    echo "Error: BASE_WS directory '${BASE_WS}' not found. Exiting setup script."
    return 1
fi

cd "${BASE_WS}" || { echo "Error: Could not change to BASE_WS directory '${BASE_WS}'."; return 1; }

echo "Navigated to ROS 2 workspace: $(pwd)"

# only build if it hasn't or if a rebuild is explicitly requested.
if [ ! -f "install/setup.bash" ] || [ "$1" == "--rebuild" ]; then
    echo "Running colcon build..."
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release
    if [ $? -ne 0 ]; then
        echo "Error: colcon build failed! Please check the build output above."
    fi
else
    echo "Workspace already built (install/setup.bash found). Skipping colcon build."
    echo "To force a rebuild, run 'wbuild --rebuild'."
fi

echo "Sourcing ROS 2 base environment..."
source /opt/ros/humble/setup.bash

echo "Sourcing workspace environment..."
source ${BASE_WS}/install/setup.bash

echo "ROS 2 workspace setup and sourced. :)"

export _ROS_WORKSPACE_SETUP_RUN=true
