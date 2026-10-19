#!/bin/bash
# ros2_node_list.sh - Landscape Script Execution: list running ROS 2 nodes.
set -uo pipefail

for s in /opt/ros/*/setup.bash; do [ -e "${s}" ] && latest="${s}"; done
# ROS setup files reference unbound vars; relax nounset while sourcing.
set +u
[ -n "${latest:-}" ] && source "${latest}"
set -u

echo "===== ros2 node list ====="
ros2 node list
