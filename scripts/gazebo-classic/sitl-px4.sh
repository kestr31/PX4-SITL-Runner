#!/bin/bash

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASIC ENVIRONMENT VARIABLE
export TERM=xterm-256color

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# SET ENVIRONMENT VARIABLES
PX4_WORKSPACE=/home/user/workspace/px4

PX4_SOURCE_DIR=${PX4_WORKSPACE}/PX4-Autopilot
PX4_SIM_DIR=${PX4_WORKSPACE}/PX4-Autopilot/Tools/simulation
PX4_BUILD_DIR=${PX4_WORKSPACE}/PX4-Autopilot/build/px4_sitl_default
PX4_BINARY_DIR=${PX4_WORKSPACE}/PX4-Autopilot/build/px4_sitl_default/bin

SITL_AIRFRAME=iris
SITL_WORLD=empty

# CHECK IF THE DIRECTORIES EXIST
CheckDirExists ${PX4_SOURCE_DIR}
CheckDirExists ${PX4_SIM_DIR}
CheckDirExists ${PX4_BUILD_DIR}
CheckDirExists ${PX4_BINARY_DIR}

# RUN GAZEBO SIDE OF THE PX4-SITL
(${PX4_SIM_DIR}/gazebo-classic/sitl_run.sh \
    ${PX4_BINARY_DIR}/px4 \
    none \
    ${SITL_AIRFRAME} \
    ${SITL_WORLD} \
    ${PX4_SOURCE_DIR} \
    ${PX4_BUILD_DIR})

sleep infinity

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<