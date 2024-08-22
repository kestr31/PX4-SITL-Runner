# COMMON ENVIRONMENT VARIABLES
## THIS VARIABLES WILL BE USED FOR SCRIPT CONTROL
# >>>----------------------------------------------------
SITL_DEPLOY_DIR=${HOME}/Documents/A4VAI-SITL
GAEZBO_HEADLESS=true
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# DEPENDENT ENVIRONMENT VARIABLES
## DO NOT MODIFY THESE VARIABLES UNLESS YOU KNOW WHAT YOU ARE DOING
# >>>----------------------------------------------------
SITL_ENV_DIR=${SITL_DEPLOY_DIR}/envs

PX4_WORKSPACE=${SITL_DEPLOY_DIR}/PX4-Autopilot
GAZEBO_CLASSIC_WORKSPACE=${SITL_DEPLOY_DIR}/Gazebo-Classic
AIRSIM_WORKSPACE=${SITL_DEPLOY_DIR}/AirSim
ROS2_WORKSPACE=${SITL_DEPLOY_DIR}/ROS2
QGC_WORKSPACE=${SITL_DEPLOY_DIR}/QGroundControl
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<