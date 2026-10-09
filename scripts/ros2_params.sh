#!/bin/bash
# ros2_params.sh - Landscape Script Execution: dump ROS 2 parameters.
# Dumps params for all nodes.
set -uo pipefail

for s in /opt/ros/*/setup.bash; do [ -e "${s}" ] && latest="${s}"; done
# ROS setup files reference unbound vars; relax nounset while sourcing.
set +u
[ -n "${latest:-}" ] && source "${latest}"
set -u

NODE=""

dump_node() {
    echo "===== ros2 param dump ${1} ====="
    timeout 10s ros2 param dump "${1}" 2>&1 || echo "(failed to dump ${1})"
    echo
}

nodes="$(timeout 10s ros2 node list 2>/dev/null || true)"
if [ -z "${nodes}" ]; then
    echo "ros2_params: no nodes found" >&2
    exit 1
fi
while IFS= read -r node; do
    [ -n "${node}" ] && dump_node "${node}"
done <<< "${nodes}"
