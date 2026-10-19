#!/bin/bash
# cmd_vel_hz.sh - Custom Graph sampler: average publish rate (Hz) of /cmd_vel.
# Prints a single number; 0 if the topic is silent.
set -uo pipefail
export HOME="${HOME:-/root}"
export USER="${USER:-root}"

for s in /opt/ros/*/setup.bash; do [ -e "${s}" ] && latest="${s}"; done
# ROS setup files reference unbound vars; relax nounset while sourcing.
set +u
[ -n "${latest:-}" ] && source "${latest}"
set -u

WINDOW_SECONDS=5
output="$(timeout "${WINDOW_SECONDS}s" ros2 topic hz /cmd_vel 2>/dev/null || true)"
rate="$(echo "${output}" | grep -oiE 'average rate:[[:space:]]*[0-9]+(\.[0-9]+)?' \
    | tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?' || true)"
[ -z "${rate}" ] && rate=0
echo "${rate}"
