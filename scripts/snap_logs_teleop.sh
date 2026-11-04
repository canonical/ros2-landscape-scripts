#!/bin/bash
# snap_logs_teleop.sh - Landscape Script Execution: return ros2-teleop snap logs.
set -uo pipefail

SNAP_NAME="ros2-teleop"

if ! command -v snap >/dev/null 2>&1; then
	echo "snap_logs_teleop: snap command not available on this host" >&2
	exit 1
fi

if ! snap list "${SNAP_NAME}" >/dev/null 2>&1; then
	echo "snap_logs_teleop: snap '${SNAP_NAME}' is not installed" >&2
	exit 1
fi

echo "===== snap logs ${SNAP_NAME} ====="

# `snap logs` requires root
snap logs "${SNAP_NAME}" -n=all
