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

CheckDirExists ${WORKSPACE_DIR}/ros2_ws/build/algorithm_test/algorithm_test/collosion_avoidance_unit_test/log create
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# CREATE LOG FILES
touch ${WORKSPACE_DIR}/logs/rs_converter.log
touch ${WORKSPACE_DIR}/logs/tf2_ros.log
touch ${WORKSPACE_DIR}/logs/direct_infer.log
touch ${WORKSPACE_DIR}/logs/point_cloud_filter_node.log
touch ${WORKSPACE_DIR}/logs/point_cloud_feature_extractor_cov.log
touch ${WORKSPACE_DIR}/logs/algorithm_test.log

# RUN THE ROS2 NODES
ros2 run algorithm_test collision_avoidance_test 2>&1 | tee ${WORKSPACE_DIR}/logs/algorithm_test.log &
ros2 run rs_converter rs_converter 2>&1 | tee ${WORKSPACE_DIR}/logs/rs_converter.log &
ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 base_link velodyne 2>&1 | tee ${WORKSPACE_DIR}/logs/tf2_ros.log &
ros2 run rs_converter point_cloud_filter_node 2>&1 | tee ${WORKSPACE_DIR}/logs/point_cloud_filter_node.log &
ros2 run rs_converter point_cloud_feature_extractor_cov 2>&1 | tee ${WORKSPACE_DIR}/logs/point_cloud_feature_extractor_cov.log &

python3 /home/user/workspace/ros2/ros2_ws/src/Python_version_easy/direct_infer.py --ros-args   -p model_path:=/home/user/workspace/ros2/ros2_ws/src/Python_version_easy/walid.onnx   -p vec_normalize_path:=/home/user/workspace/ros2/ros2_ws/src/Python_version_easy/vec_normalize.pkl   -p pointcloud_topic:=/pointcloud_features   -p cmd_topic:=/ca_vel_2_control  -p expected_points:=256 2>&1 | tee ${WORKSPACE_DIR}/logs/direct_infer.log &

rviz2

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

sleep infinity
