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

# CHECK IF STRING "MODIFIED NOT TO RUN GAZEBO ON SITL" EXISTS ON ${PX4_SIM_DIR}/gazebo-classic/sitl_run.sh
while ! grep -q "MODIFIED NOT TO RUN GAZEBO ON SITL" ${PX4_SIM_DIR}/gazebo-classic/sitl_run.sh; do
    EchoYellow "[$(basename $0)] MODIFIED NOT TO RUN GAZEBO ON SITL NOT FOUND."
    EchoYellow "[$(basename $0)] WAITING FOR THE SCRIPT TO BE MODIFIED."
    sleep 0.5s
done

cp -r /home/user/workspace/gazebo/media/* /usr/share/gazebo-11/media
cp -r /home/user/workspace/gazebo/worlds/*.world ${PX4_WORKSPACE}/PX4-Autopilot/Tools/simulation/gazebo-classic/worlds

if [ -f /home/user/workspace/gazebo/worlds/${SITL_WORLD}.sh ]; then
    EchoYellow "[$(basename $0)] ADDITIONAL SETUP SCRIPT ${SITL_WORLD}.sh FOUND."
    EcgYellow "[$(basename $0)] RUNNING ${SITL_WORLD}.sh."
    /home/user/workspace/gazebo/worlds/${SITL_WORLD}.sh
fi

# RUN GAZEBO SIDE OF THE PX4-SITL
(HEADLESS=$1 ${PX4_SIM_DIR}/gazebo-classic/sitl_run.sh \
    ${PX4_BINARY_DIR}/px4 \
    none \
    ${SITL_AIRFRAME} \
    ${SITL_WORLD} \
    ${PX4_SOURCE_DIR} \
    ${PX4_BUILD_DIR})

sleep infinity

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<