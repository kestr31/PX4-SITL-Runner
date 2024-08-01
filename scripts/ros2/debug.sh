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
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh
 
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# MAIN STATEMENTS
# >>>----------------------------------------------------

EchoGreen "[$(basename "$0")] SETTING SOURCE STATEMENT FOR ROS2 WORKSPACE"
source ${BASE_DIR}/sourceAll.sh

EchoGreen "[$(basename "$0")] DEBUG MDOE ENABLED FOR ROS2 WORKSPACE"
EchoGreen "[$(basename "$0")] THIS CONTAINER WILL DO NOTHING WHEN DEPLOYED (sleep infinity)"
sleep infinity

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<