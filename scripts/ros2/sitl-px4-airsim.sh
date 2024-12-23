#! /bin/bash

# SCRIPT TO BUILD ROS2 PACKAGE INSIDE THE CONTAINER

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASIC ENVIRONMENT VARIABLE
export TERM=xterm-256color

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))
WORKSPACE_DIR=$(dirname $(dirname $(readlink -f "$0")))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
for file in ${BASE_DIR}/include/*.sh; do
    source ${file}
done
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# MAIN STATEMENTS
# >>>----------------------------------------------------

source ${BASE_DIR}/sourceAll.sh

CheckFileExists ${BASE_DIR}/uxrce-dds.sh
CheckFileExecutable ${BASE_DIR}/uxrce-dds.sh

CheckFileExists ${BASE_DIR}/airsim-bridge.sh
CheckFileExecutable ${BASE_DIR}/airsim-bridge.sh

# CREATE DIRECTORY FOR LOGS
CheckDirExists ${WORKSPACE_DIR}/logs create
rm -rf ${WORKSPACE_DIR}/logs/*

# CREATE LOG FILES
touch ${WORKSPACE_DIR}/logs/uxrce-dds.log
touch ${WORKSPACE_DIR}/logs/airsim-bridge.log

# RUN THE SHELL SCRIPTS AND LOG THE OUTPUT
${BASE_DIR}/uxrce-dds.sh 2>&1 | tee ${WORKSPACE_DIR}/logs/uxrce-dds.log &
${BASE_DIR}/airsim-bridge.sh 2>&1 | tee ${WORKSPACE_DIR}/logs/airsim-bridge.log &

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# USER-DEFINED SATEMENTS
# >>>----------------------------------------------------

touch ${WORKSPACE_DIR}/logs/uxrce-dds.log
touch ${WORKSPACE_DIR}/logs/airsim-bridge.log
touch ${WORKSPACE_DIR}/logs/controller.log
touch ${WORKSPACE_DIR}/logs/Plan2WP.log
touch ${WORKSPACE_DIR}/logs/node_MPPI_output.log
touch ${WORKSPACE_DIR}/logs/node_att_ctrl.log
touch ${WORKSPACE_DIR}/logs/collision_avoidance.log
touch ${WORKSPACE_DIR}/logs/pub_depth.log
touch ${WORKSPACE_DIR}/logs/plot.log

mkdir -p /home/user/workspace/ros2/ros2_ws/log/point_mass_6d/datalogfile

ros2 run controller controller 2>&1 | tee ${WORKSPACE_DIR}/logs/controller.log &
ros2 run pathplanning Plan2WP 2>&1 | tee ${WORKSPACE_DIR}/logs/Plan2WP.log &
ros2 run pathfollowing node_MPPI_output 2>&1 | tee ${WORKSPACE_DIR}/logs/node_MPPI_output.log &
ros2 run pathfollowing node_att_ctrl 2>&1 | tee ${WORKSPACE_DIR}/logs/node_att_ctrl.log &
ros2 run collision_avoidance collision_avoidance 2>&1 | tee ${WORKSPACE_DIR}/logs/collision_avoidance.log &
ros2 run pub_depth pub_depth 2>&1 | tee ${WORKSPACE_DIR}/logs/pub_depth.log &
ros2 run plotter plot 2>&1 | tee ${WORKSPACE_DIR}/logs/plot.log &

# LOGGING ALL TOPICS TO BAG FILE
ros2 bag record -a -o ${WORKSPACE_DIR}/logs/rosbag 2>&1 | tee ${WORKSPACE_DIR}/logs/plot.log &

${WORKSPACE_DIR}/rosboard/run

# PLACE USER-DEFINED SHELL SCRIPTS/COMMANDS HERE
# FOR EXAMPLE FOR RUNNING:
#   algorithm1 build at /home/user/workspace/ros2/alg_ws
# PLACE THE FOLLOWING COMMAND OR CREATE A SHELL SCRIPT WITH THE COMMAND:
#   source /opt/ros/${ROS_DISTRO}/setup.bash
#   source /home/user/workspace/ros2/alg_ws/install/setup.bash
#   ros2 run algorithm1 algorithm1_node
# CHECK uxrce-dds.sh, airsim-bridge.sh, AND THIS SCRIPT FOR EXAMPLES

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

sleep infinity
