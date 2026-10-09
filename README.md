# ros2-landscape-scripts

Bash scripts for monitoring and inspecting ROS 2 robots through [Landscape](https://ubuntu.com/landscape).
Upload the files in `scripts/` to Landscape to run them on your robots.
To monitor ROS topic values or any value from your robot,
create custom graphs in the Landscape web UI using the code in `graphs/`.

This repository is meant as a starting point for your ROS 2/Landscape journey.
Make sure to adapt the scripts to your usage and to your setup.

## Available scripts

| File | Purpose |
|------|---------|
| `graphs/battery_percentage.sh` | Read an integer percentage from the `/battery` topic (`data` field) |
| `graphs/cmd_vel_hz.sh` | Measure `/cmd_vel` publish rate over 5 seconds; return `0` if no rate is captured |
| `scripts/ros2_node_list.sh` | List discovered ROS 2 nodes |
| `scripts/ros2_params.sh` | Dump parameters for all discovered nodes |
| `scripts/ros_logs.sh` | Return full `.log` files from the latest ROS log directory |
| `scripts/snap_logs_teleop.sh` | Return all available `ros2-teleop` snap logs |
| `scripts/enable_ros_esm.sh` | Enable ROS ESM and upgrade system packages. This requires the device to have a valid Ubuntu Pro token attached |

## ROS environment

The node, parameter,
and graph scripts source the last matching
`/opt/ros/*/setup.bash` in shell glob order.

If multiple distributions are installed,
adjust the script to source the one your robot uses.

These scripts must use the same discovery settings as the running ROS nodes.
If your robot uses a non-default `ROS_DOMAIN_ID`, `RMW_IMPLEMENTATION`,
or DDS configuration,
add the required exports to the relevant scripts.

ROS logs are read from the run-as user's home directory,
so adjust the log path or run-as user accordingly.
Snap logs require root.

When uploading scripts,
make sure to select the relevant user to run them.
Run ROS discovery and log scripts as the user running your ROS 2 nodes.
Run snap-log and ROS ESM scripts as root.

## Upload scripts to Landscape

Install and configure the [`landscape-api`](https://snapcraft.io/landscape-api) CLI,
then run from this directory:

```bash
sudo snap install landscape-api
export LANDSCAPE_API_KEY=...
export LANDSCAPE_API_SECRET=...
export LANDSCAPE_API_URI=https://<landscape-host>/api/
# If your server uses a custom certificate authority:
export LANDSCAPE_API_SSL_CA_FILE=~/path/to/landscape_server_ca.crt
```

We can then upload scripts with:
```bash
landscape-api create-script "ROS2 - enable ROS ESM" 1800 scripts/enable_ros_esm.sh --username root
```

You can also paste the script content directly under "Organisation", "Scripts".

## Use scripts

In Landscape, select the target computers,
choose a stored script from the script execution UI.

Read the execution result in the computer's Activities.
Landscape may truncate large outputs,
even though the log scripts request complete logs.

## Upload graphs to Landscape

In the Landscape web UI,
select “Organisation”, then “Graphs”.
Create a custom graph and paste the contents of the desired file from `graphs/`.
Each graph script must print a single numeric value.

## Use graphs

Graph scripts are run automatically by Landscape.
View graphs in the computer’s "Monitoring" section.
Additionally, you can download the CSV corresponding to a graph.
