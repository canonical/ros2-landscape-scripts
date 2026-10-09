#!/bin/bash
# battery_percentage.sh - Custom Graph sampler: /battery (UInt32 .data) -> %.
# Prints a single integer. /battery must be latched (transient_local QoS).
set -euo pipefail
export HOME="${HOME:-/root}"
export USER="${USER:-root}"

for s in /opt/ros/*/setup.bash; do [ -e "${s}" ] && latest="${s}"; done
# ROS setup files reference unbound vars; relax nounset while sourcing.
set +u
[ -n "${latest:-}" ] && source "${latest}"
set -u

# Capture raw output first (|| true: tolerate timeout / SIGPIPE under pipefail),
# then take the first line before the `---` YAML separator that echo appends.
raw="$(timeout 60s ros2 topic echo --once --field data /battery 2>/dev/null || true)"
value="$(printf '%s\n' "${raw}" | head -n 1 | tr -d '[:space:]')"
if ! [[ "${value}" =~ ^[0-9]+$ ]]; then
    echo "could not read integer from /battery (got: '${value}')" >&2
    exit 1
fi
echo "${value}"
