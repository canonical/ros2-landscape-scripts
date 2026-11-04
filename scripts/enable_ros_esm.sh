#!/bin/bash
# enable_ros_esm.sh - Enable ROS ESM for the device.
# ROS ESM requires an attached Ubuntu Pro subscription with ROS entitlement.
# Run this script during a maintenance window:
# it upgrades all eligible system packages and may require interactive input.
set -euo pipefail

apt update
apt install --yes ubuntu-pro-client

pro attach "${PRO_TOKEN:?Set PRO_TOKEN to your Ubuntu Pro token}"
pro enable ros

apt update
apt upgrade --yes
echo "===== ROS ESM successfully installed ====="
