# Containerized PX4 SITL Run Script

## Initial Setup

- Clone this repository

```bash
git clone https://github.com/kestr31/PX4-SITL-Runner.git
```

- Move to the cloned repository
- Then, run the following command to clone and build the PX4 SITL.
- The assets will be located under `${HOME}/PX4-SITL-Runner/px4` by default.

```bash
cd PX4-SITL-Runner
./script/run.sh px4 clone
./script/run.sh px4 build
```

- Next, place the `GazeboDrone` under the Gazebo-Classic workspace.
  - The workspace is set to `${HOME}/Documents/A4VAI-SITL/Gazebo-Classic` by default.
- It is a prebuit Gazebo - Airsim bridge with slight modification. (Can read env. var. `AIRSIM_IP`)
  - Please make sure the `GazeboDrone` is executable.
  - You can do it by running `chmod +x GazeboDrone`.
<br>

- Next, place prebuilt ROS packages under the ROS workspace.
  - The workspace is set to `${HOME}/Documents/A4VAI-SITL/ROS2` by default.
- Packages are provieded in `*.tar.gz` format.
  - Please extract the packages under the workspace.

```bash
tar -zxvf ${HOME}/Documents/A4VAI-SITL/ROS2/airsim.tar.gz -C ${HOME}/Documents/A4VAI-SITL/ROS2
tar -zxvf ${HOME}/Documents/A4VAI-SITL/ROS2/px4_ros.tar.gz -C ${HOME}/Documents/A4VAI-SITL/ROS2
```

- Lastly, place AirSim Unreal binary and `settings.json` under the AirSim workspace.
  - The workspace is set to `${HOME}/Documents/A4VAI-SITL/AirSim` by default.
- The directory name of the binary must be `binary`.
  - The `*.sh` script inside the `binary` directory must be executable.

<br/>

- Everything is now set up.
- Make sure to enter `xhost +` on each reboot to allow the container to access the host's display.
- You can now run the PX4 SITL with the following command.

```bash
xhost +
./scripts/run.sh gazebo-classic-airsim-sitl run
```

- You can kill the PX4 SITL with the following command.

```bash
./scripts/run.sh gazebo-classic-airsim-sitl run
```

- If you need a "debug", you can halt every container with the following command.
- Every container will run with entrypoint `sleep infinity`.

```bash
./scripts/run.sh gazebo-classic-airsim-sitl debug
```