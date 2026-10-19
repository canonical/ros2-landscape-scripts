#!/bin/bash
# ros_logs.sh - Landscape Script Execution: return ROS 2 node logs from the latest run.
set -uo pipefail

# ROS 2 writes per-run logs under ~/.ros/log/<timestamp>/ with a `latest`
# symlink to the most recent run.
LOG_DIR="${HOME}/.ros/log"
LATEST="${LOG_DIR}/latest"

if [ ! -d "${LATEST}" ]; then
	echo "ros_logs: no ROS log directory found at ${LATEST}" >&2
	exit 1
fi

shopt -s nullglob
files=("${LATEST}"/*.log)
if [ ${#files[@]} -eq 0 ]; then
	echo "ros_logs: no .log files under ${LATEST}" >&2
	exit 1
fi

for f in "${files[@]}"; do
	echo "===== ${f} ====="
	cat "${f}"
	echo
done
