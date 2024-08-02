#!/bin/bash

# SCRIPT TO RUN CONTAINER FOR TESTING

# INITIAL STATEMENTS
# >>>----------------------------------------------------

# SET THE BASE DIRECTORY
BASE_DIR=$(dirname $(readlink -f "$0"))
REPO_DIR=$(dirname $(dirname $(readlink -f "$0")))

# SOURCE THE ENVIRONMENT AND FUNCTION DEFINITIONS
source ${BASE_DIR}/include/commonFcn.sh
source ${BASE_DIR}/include/commonEnv.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# DEFINE USAGE FUNCTION
# >>>----------------------------------------------------

# FIRST ARGUMENTS: gazebo-classic-sitl, gazebo-classic-airsim-sitl, px4, gazebo-classic, airsim, ros2, qgc
usageState1(){
    EchoRed "Usage: $0 [gazebo-classic-sitl|gazebo-classic-airsim-sitl|px4|gazebo-classic|airsim|ros2|qgc]"
    EchoRed "gazebo-classic-sitl: DEPLOY GAZEBO SITL CONTAINERS"
    EchoRed "gazebo-classic-airism-sitl: DEPLOY GAZEBO-AIRSIM SITL CONTAINERS"
    EchoRed "px4: DEPLOY PX4-AUTOPILOT CONTAINER"
    EchoRed "gazebo-classic: DEPLOY GAZEBO-CLASSIC CONTAINER"
    EchoRed "gazebo: DEPLOY GAZEBO CONTAINER"
    EchoRed "airsim: DEPLOY AIRSIM CONTAINER"
    EchoRed "ros2: DEPLOY ROS2 CONTAINER"
    EchoRed "qgc: DEPLOY QGroundControl CONTAINER"
    exit 1
}

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# CHECK IF ANY INPUT ARGUMENTS ARE PROVIDED
# >>>----------------------------------------------------

# FIRST ARGUMENTS CHECK: gazebo-classic-sitl, gazebo-classic-airsim-sitl, px4, gazebo-classic, gazebo, airsim, ros2, qgc
if [ $# -eq 0 ]; then
    usageState1 $0
else
    if [ "$1x" != "gazebo-classic-sitlx" ] && \
       [ "$1x" != "gazebo-classic-airsim-sitlx" ] && \
       [ "$1x" != "px4x" ] && \
       [ "$1x" != "gazebo-classicx" ] && \
       [ "$1x" != "gazebox" ] && \
       [ "$1x" != "airsimx" ] && \
       [ "$1x" != "ros2x" ] && \
       [ "$1x" != "qgcx" ]; then
        EchoRed "[$(basename "$0")] INVALID INPUT \"$1\". PLEASE USE ARGUMENT AMONG
        \"gazebo-classic-sitl\"
        \"gazebo-classic-airsim-sitl\"
        \"px4\"
        \"gazebo-classic\"
        \"gazebo\"
        \"airsim\"
        \"ros2\"
        \"qgc\""
        exit 1
    fi
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# RUN PROCESS PER ARGUMENT
# >>>----------------------------------------------------

PX4_WORKSPACE=${SITL_DEPLOY_DIR}/PX4-Autopilot
GAZEBO_CLASSIC_WORKSPACE=${SITL_DEPLOY_DIR}/Gazebo-Classic
AIRSIM_WORKSPACE=${SITL_DEPLOY_DIR}/AirSim
ROS2_WORKSPACE=${SITL_DEPLOY_DIR}/ROS2
QGC_WORKSPACE=${SITL_DEPLOY_DIR}/QGroundControl

CheckDirExists ${SITL_DEPLOY_DIR} create

CheckDirExists ${PX4_WORKSPACE} create
CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE} create
CheckDirExists ${AIRSIM_WORKSPACE} create
CheckDirExists ${ROS2_WORKSPACE} create
CheckDirExists ${QGC_WORKSPACE} create

cp ${REPO_DIR}/compose.yml ${SITL_DEPLOY_DIR}/compose.yml
cp -r ${REPO_DIR}/envs ${SITL_DEPLOY_DIR}

# SET DISPLAY AND AUDIO-RELATED ENVIRONMENT VARIABLES TO THE .env FILE
SetComposeDisplay ${SITL_ENV_DIR}/common.env

# SET WORKSPACE VARIABLES

# SET PX4_WORKSPACE TO THE .env FILE
EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${SITL_ENV_DIR}/px4.env

# SET GAZEBO_CLASSIC_WORKSPACE TO THE .env FILE
EchoGreen "[$(basename "$0")] SETTING GAZEBO_CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${SITL_ENV_DIR}/gazebo-classic.env

# SET AIRSIM_WORKSPACE TO THE .env FILE
EchoGreen "[$(basename "$0")] SETTING AIRSIM_WORKSPACE AS ${AIRSIM_WORKSPACE}"
sed -i "s~AIRSIM_WORKSPACE=\"\"~AIRSIM_WORKSPACE=${AIRSIM_WORKSPACE}~" ${SITL_ENV_DIR}/airsim.env

# SET ROS2_WORKSPACE TO THE .env FILE
EchoGreen "[$(basename "$0")] SETTING ROS2_WORKSPACE AS ${ROS2_WORKSPACE}"
sed -i "s~ROS2_WORKSPACE=\"\"~ROS2_WORKSPACE=${ROS2_WORKSPACE}~" ${SITL_ENV_DIR}/ros2.env

# SET QGC_WORKSPACE TO THE .env FILE
EchoGreen "[$(basename "$0")] SETTING QGC_WORKSPACE AS ${QGC_WORKSPACE}"
sed -i "s~QGC_WORKSPACE=\"\"~QGC_WORKSPACE=${QGC_WORKSPACE}~" ${SITL_ENV_DIR}/qgc.env


if [ "$1x" == "gazebo-classic-sitlx" ]; then
    # SECOND ARGUMENTS: run, debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 px4 [clone|build|clean|sitl-gazebo-classic|debug|stop]"
        EchoRed "run:   RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"
        EchoRed "debug: RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "runx" ] && \
       [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug
        else
            # SET PX4_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
            sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${SITL_ENV_DIR}/px4.env

            # SET GAZEBO_CLASSIC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING GAZEBO_CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
            sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${SITL_ENV_DIR}/gazebo-classic.env

            # SET ROS2_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING ROS2_WORKSPACE AS ${ROS2_WORKSPACE}"
            sed -i "s~ROS2_WORKSPACE=\"\"~ROS2_WORKSPACE=${ROS2_WORKSPACE}~" ${SITL_ENV_DIR}/ros2.env

            # SET QGC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING QGC_WORKSPACE AS ${QGC_WORKSPACE}"
            sed -i "s~QGC_WORKSPACE=\"\"~QGC_WORKSPACE=${QGC_WORKSPACE}~" ${SITL_ENV_DIR}/qgc.env

            # CREATE SCRIPTS AND INCLUDE DIRECTORIES
            CheckDirExists ${PX4_WORKSPACE}/scripts create
            CheckDirExists ${PX4_WORKSPACE}/scripts/include create
            CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts create
            CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts/include create
            CheckDirExists ${ROS2_WORKSPACE}/scripts create
            CheckDirExists ${ROS2_WORKSPACE}/scripts/include create
            CheckDirExists ${QGC_WORKSPACE}/scripts create
            CheckDirExists ${QGC_WORKSPACE}/scripts/include create

            # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
            cp -r ${BASE_DIR}/px4/* ${PX4_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${PX4_WORKSPACE}/scripts/include
            cp -r ${BASE_DIR}/gazebo-classic/* ${GAZEBO_CLASSIC_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${GAZEBO_CLASSIC_WORKSPACE}/scripts/include

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC-SITL CONTAINERs IN DEBUG MODE."
                # WHEN NUMBER OF ARGUMENTS IS 2
                if [ $# -eq 2 ]; then
                    EchoYellow "[$(basename "$0")] SETTING ALL CONTAINERS IN DEBUG MODE (sleep infinity)"
                    sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/px4.env
                    sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/gazebo-classic.env

                    SCRIPT_NAME="debug.sh"
                    CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                    CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                    # SET THE RUN COMMAND TO THE .env FILE
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/ros2/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env

                    sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'~g" ${SITL_ENV_DIR}/qgc.env
                else
                    # FOR EACH ARGUMENT STARTING FROM THE THIRD ARGUMENT, SET THE COMMAND TO THE .env FILE
                    for arg in "${@:3}"; do
                        if [ "${arg}x" == "px4x" ]; then
                            EchoYellow "[$(basename "$0")] SETTING PX4-AUTOPILOT SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/px4.env
                        elif [ "${arg}x" == "gazebo-classicx" ]; then
                            EchoYellow "[$(basename "$0")] SETTING GAZEBO-CLASSIC SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/gazebo-classic.env
                        elif [ "${arg}x" == "ros2x" ]; then
                            EchoYellow "[$(basename "$0")] SETTING ROS2 SITL IN DEBUG MODE (sleep infinity)"
                            SCRIPT_NAME="debug.sh"
                            CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                            CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                            # SET THE RUN COMMAND TO THE .env FILE
                            sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/ros2/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                        elif [ "${arg}x" == "qgcx" ]; then
                            EchoYellow "[$(basename "$0")] SETTING QGroundControl SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'~g" ${SITL_ENV_DIR}/qgc.env
                        else
                            EchoRed "[$(basename "$0")] INVALID INPUT \"$arg\". PLEASE USE ARGUMENT AMONG"
                            EchoRed "  \"px4\""
                            EchoRed "  \"gazebo-classic\""
                            EchoRed "  \"ros2\""
                            EchoRed "  \"qgc\""
                            EchoRed  "TO STOP THE CONTAINER SELECTIVELY OR LEAVE IT EMPTY TO STOP EVERYTHING."
                            exit 1
                        fi
                    done
                fi
                EchoGreen "[$(basename "$0")] RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"

                SCRIPT_NAME="sitl-gazebo-classic.sh"
                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env

                SCRIPT_NAME="sitl-px4.sh "
                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~GAZEBO_CLASSIC_RUN_COMMAND=\"\"~GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"/home/user/workspace/gazebo/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/gazebo-classic.env
                
                sed -i "s/ROS2_RUN_COMMAND=\"\"/ROS2_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/ros2.env
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"/usr/local/bin/entrypoint.sh\"\'~g" ${SITL_ENV_DIR}/qgc.env
            elif [ "$2x" == "runx" ]; then
                EchoGreen "[$(basename "$0")] RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"

                SCRIPT_NAME="sitl-gazebo-classic.sh"
                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env

                SCRIPT_NAME="sitl-px4.sh "
                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~GAZEBO_CLASSIC_RUN_COMMAND=\"\"~GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"/home/user/workspace/gazebo/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/gazebo-classic.env
                
                sed -i "s/ROS2_RUN_COMMAND=\"\"/ROS2_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/ros2.env
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"/usr/local/bin/entrypoint.sh\"\'~g" ${SITL_ENV_DIR}/qgc.env
            fi
        fi
    fi

elif [ "$1x" == "gazebo-classic-airsim-sitlx" ]; then
    # EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    # exit 1

    # SECOND ARGUMENTS: run, debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 px4 [clone|build|clean|sitl-gazebo-classic|debug|stop]"
        EchoRed "run:   RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"
        EchoRed "debug: RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "runx" ] && \
       [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug
        else
            # SET PX4_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
            sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${SITL_ENV_DIR}/px4.env

            # SET GAZEBO_CLASSIC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING GAZEBO_CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
            sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${SITL_ENV_DIR}/gazebo-classic.env

            # SET AIRSIM_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING AIRSIM_WORKSPACE AS ${AIRSIM_WORKSPACE}"
            sed -i "s~AIRSIM_WORKSPACE=\"\"~AIRSIM_WORKSPACE=${AIRSIM_WORKSPACE}~" ${SITL_ENV_DIR}/airsim.env

            # SET QGC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING QGC_WORKSPACE AS ${QGC_WORKSPACE}"
            sed -i "s~QGC_WORKSPACE=\"\"~QGC_WORKSPACE=${QGC_WORKSPACE}~" ${SITL_ENV_DIR}/qgc.env

            # CREATE SCRIPTS AND INCLUDE DIRECTORIES
            CheckDirExists ${PX4_WORKSPACE}/scripts create
            CheckDirExists ${PX4_WORKSPACE}/scripts/include create
            CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts create
            CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts/include create
            CheckDirExists ${AIRSIM_WORKSPACE}/scripts create
            CheckDirExists ${AIRSIM_WORKSPACE}/scripts/include create
            CheckDirExists ${ROS2_WORKSPACE}/scripts create
            CheckDirExists ${ROS2_WORKSPACE}/scripts/include create
            CheckDirExists ${QGC_WORKSPACE}/scripts create
            CheckDirExists ${QGC_WORKSPACE}/scripts/include create

            # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
            cp -r ${BASE_DIR}/px4/* ${PX4_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${PX4_WORKSPACE}/scripts/include
            cp -r ${BASE_DIR}/gazebo-classic/* ${GAZEBO_CLASSIC_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${GAZEBO_CLASSIC_WORKSPACE}/scripts/include
            cp -r ${BASE_DIR}/airsim/* ${AIRSIM_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${AIRSIM_WORKSPACE}/scripts/include
            cp -r ${BASE_DIR}/ros2/* ${ROS2_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${ROS2_WORKSPACE}/scripts/include

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC-SITL CONTAINERs IN DEBUG MODE."
                # WHEN NUMBER OF ARGUMENTS IS 2
                if [ $# -eq 2 ]; then
                    EchoYellow "[$(basename "$0")] SETTING ALL CONTAINERS IN DEBUG MODE (sleep infinity)"
                    sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/px4.env
                    sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/gazebo-classic.env
                    sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/airsim.env

                    SCRIPT_NAME="debug.sh"
                    CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                    CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                    # SET THE RUN COMMAND TO THE .env FILE
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/ros2/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env

                    sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'~g" ${SITL_ENV_DIR}/qgc.env
                else
                    # FOR EACH ARGUMENT STARTING FROM THE THIRD ARGUMENT, SET THE COMMAND TO THE .env FILE
                    for arg in "${@:3}"; do
                    echo $arg
                        if [ "${arg}x" == "px4x" ]; then
                            EchoYellow "[$(basename "$0")] SETTING PX4-AUTOPILOT SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/px4.env
                        elif [ "${arg}x" == "gazebo-classicx" ]; then
                            EchoYellow "[$(basename "$0")] SETTING GAZEBO-CLASSIC SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/gazebo-classic.env
                        elif [ "${arg}x" == "airsimx" ]; then
                            EchoYellow "[$(basename "$0")] SETTING AIRSIM SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/airsim.env
                        elif [ "${arg}x" == "ros2x" ]; then
                            EchoYellow "[$(basename "$0")] SETTING ROS2 SITL IN DEBUG MODE (sleep infinity)"
                            SCRIPT_NAME="debug.sh"
                            CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                            CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                            # SET THE RUN COMMAND TO THE .env FILE
                            sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/ros2/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                        elif [ "${arg}x" == "qgcx" ]; then
                            EchoYellow "[$(basename "$0")] SETTING QGroundControl SITL IN DEBUG MODE (sleep infinity)"
                            sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'~g" ${SITL_ENV_DIR}/qgc.env
                        else
                            EchoRed "[$(basename "$0")] INVALID INPUT \"$arg\". PLEASE USE ARGUMENT AMONG"
                            EchoRed "  \"px4\""
                            EchoRed "  \"gazebo-classic\""
                            EchoRed "  \"airsim\""
                            EchoRed "  \"ros2\""
                            EchoRed "  \"qgc\""
                            EchoRed  "TO STOP THE CONTAINER SELECTIVELY OR LEAVE IT EMPTY TO STOP EVERYTHING."
                            exit 1
                        fi
                    done
                fi
                EchoGreen "[$(basename "$0")] RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"

                SCRIPT_NAME="sitl-gazebo-classic-airsim.sh"

                CheckFileExists ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env

                SCRIPT_NAME="sitl-px4.sh"

                CheckFileExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${GAZEBO_CLASSIC_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~GAZEBO_CLASSIC_RUN_COMMAND=\"\"~GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"/home/user/workspace/gazebo/scripts/${SCRIPT_NAME} 1\"\'~g" ${SITL_ENV_DIR}/gazebo-classic.env
                
                SCRIPT_NAME="auto.sh"

                CheckFileExists ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}

                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/airsim.env

                SCRIPT_NAME="sitl-px4-airsim.sh"

                CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                
                sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/ros2/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"/usr/local/bin/entrypoint.sh\"\'~g" ${SITL_ENV_DIR}/qgc.env
            elif [ "$2x" == "runx" ]; then
                EchoGreen "[$(basename "$0")] RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"

                SCRIPT_NAME="sitl-gazebo-classic-airsim.sh"

                CheckFileExists ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env

                SCRIPT_NAME="sitl-px4.sh"

                CheckFileExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${GAZEBO_CLASSIC_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~GAZEBO_CLASSIC_RUN_COMMAND=\"\"~GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"/home/user/workspace/gazebo/scripts/${SCRIPT_NAME} 1\"\'~g" ${SITL_ENV_DIR}/gazebo-classic.env
                
                SCRIPT_NAME="auto.sh"

                CheckFileExists ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}

                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/airsim.env

                SCRIPT_NAME="sitl-px4-airsim.sh"

                CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                
                sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/ros2/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"/usr/local/bin/entrypoint.sh\"\'~g" ${SITL_ENV_DIR}/qgc.env
            fi
        fi
    fi

elif [ "$1x" == "px4x" ]; then
    # SECOND ARGUMENTS: debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 px4 [clone|build|clean|sitl-gazebo-classic|debug|stop]"
        EchoRed "clone: CLONE PX4-AUTOPILOT REPOSITORY"
        EchoRed "build: BUILD PX4-AUTOPILOT INSIDE THE CONTAINER"
        EchoRed "clean: CLEAN PX4-AUTOPILOT BUILD"
        EchoRed "sitl-gazebo-classic-standalone: RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC IN STANDALONE MODE (ON ONE CONTAINER)"
        EchoRed "debug: RUN PX4-AUTOPILOT CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP PX4-AUTOPILOT CONTAINER IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "clonex" ] && \
       [ "$2x" != "buildx" ] && \
       [ "$2x" != "cleanx" ] && \
       [ "$2x" != "sitl-gazebo-classic-standalonex" ] && \
       [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug
        else
            # SET PX4_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
            sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${SITL_ENV_DIR}/px4.env

            EchoYellow "[$(basename "$0")] COPYING SCRIPTS TO THE PX4_WORKSPACE"

            # CREATE SCRIPTS AND INCLUDE DIRECTORIES
            CheckDirExists ${PX4_WORKSPACE}/scripts create
            CheckDirExists ${PX4_WORKSPACE}/scripts/include create

            # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
            cp -r ${BASE_DIR}/$1/* ${PX4_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${PX4_WORKSPACE}/scripts/include

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER IN DEBUG MODE."
                sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/px4.env
            elif [ "$2x" == "clonex" ]; then
                EchoGreen "[$(basename "$0")] CLONE PX4-AUTOPILOT REPOSITORY TO THE PX4_WORKSPACE"
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE PROCESS"

                SCRIPT_NAME="clone.sh"

                CheckFileExists ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env
            elif [ "$2x" == "buildx" ]; then
                EchoGreen "[$(basename "$0")] BUILD PX4-AUTOPILOT INSIDE THE CONTAINER"
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE BUILD PROCESS."

                SCRIPT_NAME="build.sh"

                CheckFileExists ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env
            elif [ "$2x" == "cleanx" ]; then
                EchoGreen "[$(basename "$0")] CLEAN PX4-AUTOPILOT BUILD INSIDE THE CONTAINER"
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE CLEAN PROCESS."

                SCRIPT_NAME="clean.sh"

                CheckFileExists ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env
            elif [ "$2x" == "sitl-gazebo-classic-standalonex" ]; then
                EchoGreen "[$(basename "$0")] RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"

                SCRIPT_NAME="sitl-gazebo-classic-standalone.sh"

                CheckFileExists ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${PX4_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/px4.env
            fi

            EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER..."
        fi
    fi

elif [ "$1x" == "gazebo-classicx" ]; then
    # SECOND ARGUMENTS: debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 gazebo-classic [sitl-px4|debug|stop]"
        EchoRed "sitl-px4:  RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"
        EchoRed "debug: RUN GAZEBO-CLASSIC CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP GAZEBO-CLASSIC CONTAINER IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: sitl, debug, stop
    if [ "$2x" != "sitl-px4x" ] && \
       [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug
        else
            # SET GAZEBO_CLASSIC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING GAZEBO_CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
            sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${SITL_ENV_DIR}/gazebo-classic.env

            EchoYellow "[$(basename "$0")] COPYING SCRIPTS TO THE GAZEBO_CLASSIC_WORKSPACE"

            # CREATE SCRIPTS AND INCLUDE DIRECTORIES
            CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts create
            CheckDirExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts/include create

            # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
            cp -r ${BASE_DIR}/$1/* ${GAZEBO_CLASSIC_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${GAZEBO_CLASSIC_WORKSPACE}/scripts/include

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER IN DEBUG MODE."
                sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/gazebo-classic.env
            elif [ "$2x" == "sitl-px4x" ]; then
                EchoGreen "[$(basename "$0")] RUN PX4-AUTOPILOT SITL IN GAZEBO-CLASSIC"

                SCRIPT_NAME="sitl-px4.sh"

                CheckFileExists ${GAZEBO_CLASSIC_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${GAZEBO_CLASSIC_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~GAZEBO_CLASSIC_RUN_COMMAND=\"\"~GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"/home/user/workspace/gazebo/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/gazebo-classic.env
            fi

            EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER..."
        fi
    fi

elif [ "$1x" == "gazebox" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
elif [ "$1x" == "airsimx" ]; then
    # SECOND ARGUMENTS: debug, stop, auto, *.sh
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 airsim [debug|auto|*.sh]"
        EchoRed "debug: RUN AIRSIM CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP AIRSIM CONTAINER IF IT IS RUNNING"
        EchoRed "auto: RUN AIRSIM CONTAINER IN AUTO MODE (run .sh file in /home/ue4/workspace/binary)"
        EchoRed "*.sh: RUN AIRSIM CONTAINER IN MANUAL MODE (run specific .sh file)"
        exit 1
    }

   # SECOND ARGUMENT CHECK: debug, stop, auto, *.sh
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ] && \
       [ "$2x" != "autox" ] && \
       [[ "$2x" != *".shx" ]]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug, auto, *.sh
        else
            # set AIRSIM_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING AIRSIM_WORKSPACE AS ${AIRSIM_WORKSPACE}"
            sed -i "s~AIRSIM_WORKSPACE=\"\"~AIRSIM_WORKSPACE=${AIRSIM_WORKSPACE}~" ${SITL_ENV_DIR}/airsim.env

            EchoYellow "[$(basename "$0")] COPYING SCRIPTS TO THE AIRSIM_WORKSPACE"

            # CREATE SCRIPTS AND INCLUDE DIRECTORIES
            CheckDirExists ${AIRSIM_WORKSPACE}/scripts create
            CheckDirExists ${AIRSIM_WORKSPACE}/scripts/include create

            # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
            cp -r ${BASE_DIR}/$1/* ${AIRSIM_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${AIRSIM_WORKSPACE}/scripts/include

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN DEBUG MODE."
                sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/airsim.env
            # ACTION: auto. RUN THE CONTAINER IN AUTO MODE (run .sh file in /home/ue4/workspace/binary)
            elif [ "$2x" == "autox" ]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN AUTO MODE."
                EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL FIND AND RUN .sh FILE IN /home/ue4/workspace/binary DIRECTORY."

                SCRIPT_NAME="auto.sh"

                CheckFileExists ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/airsim.env
            # ACTION: *.sh. RUN THE CONTAINER IN MANUAL MODE (run specific .sh file)
            elif [[ "$2x" == *".shx" ]]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER WITH $2"

                SCRIPT_NAME=$2

                CheckFileExists ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${AIRSIM_WORKSPACE}/scripts/${SCRIPT_NAME}

                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/airsim.env
            fi

            EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER..."
        fi
    fi

elif [ "$1x" == "ros2x" ]; then
    # SECOND ARGUMENTS: debug, stop, build, *.sh
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 ros2 [debug|stop|build|*.sh] (target_workspace)"
        EchoRed "debug: RUN ROS2 CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP ROS2 CONTAINER IF IT IS RUNNING"
        EchoRed "build: BUILD ROS2 PACKAGES INSIDE THE CONTAINER"
        EchoRed "  target_workspace: TARGET WORKSPACE TO BUILD ROS2 PACKAGES (optional, only for \"build\")"
        EchoRed "*.sh: RUN ROS2 CONTAINER IN MANUAL MODE (run specific shell script)"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop, build, *.sh
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ] && \
       [ "$2x" != "buildx" ] && \
       [[ "$2x" != *".shx" ]]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug, build, *.sh
        else
            # SET ROS2_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING ROS2_WORKSPACE AS ${ROS2_WORKSPACE}"
            sed -i "s~ROS2_WORKSPACE=\"\"~ROS2_WORKSPACE=${ROS2_WORKSPACE}~" ${SITL_ENV_DIR}/ros2.env

            EchoYellow "[$(basename "$0")] COPYING SCRIPTS TO THE AIRSIM_WORKSPACE"

            # CREATE SCRIPTS AND INCLUDE DIRECTORIES
            CheckDirExists ${ROS2_WORKSPACE}/scripts create
            CheckDirExists ${ROS2_WORKSPACE}/scripts/include create

            # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
            cp -r ${BASE_DIR}/$1/* ${ROS2_WORKSPACE}/scripts/
            cp -r ${BASE_DIR}/include/* ${ROS2_WORKSPACE}/scripts/include

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                SCRIPT_NAME="debug.sh"

                CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/$1/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env
            # ACTION: build. BUILD ROS2 PACKAGES INSIDE THE CONTAINER
            elif [ "$2x" == "buildx" ]; then
                EchoGreen "[$(basename "$0")] BUILDING ROS2 PACKAGES INSIDE THE CONTAINER."
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE BUILD PROCESS."

                SCRIPT_NAME="build.sh"

                CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}

                # IF ADDITIONAL DIRECTORIES ARE PROVIDED, PASS THEM TO THE BUILD SCRIPT
                if [ $# -ge 3 ]; then
                    # DUE TO SED ESCAPE ISSUE, ADDITIONAL ENVIRONMENT VARIABLE IS SET
                    TARGET_ROS2_WORKSPACES=${@:3}
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/$1/scripts/${SCRIPT_NAME} ${TARGET_ROS2_WORKSPACES}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                # ELSE, RUN THE BUILD SCRIPT. THIS WILL BUILD ALL PACKAGES IN THE ALL DIRECTORIES THAT HAVE NON-EMPTY 'src' SUBDIRECTORY
                else
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/$1/scripts/${SCRIPT_NAME}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                fi 
            # ACTION: *.sh. RUN THE CONTAINER IN MANUAL MODE (RUN SPECIFIC SHELL SCRIPT)
            elif [[ "$2x" == *".shx" ]]; then
                EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER WITH $2"

                SCRIPT_NAME=$2

                CheckFileExists ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}
                CheckFileExecutable ${ROS2_WORKSPACE}/scripts/${SCRIPT_NAME}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/$1/$2\"\'~g" ${SITL_ENV_DIR}/ros2.env
            fi

            EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER..."
        fi
    fi

elif [ "$1x" == "qgcx" ]; then
    # SECOND ARGUMENTS: debug, stop, run
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 qgc [debug|stop|run]"
        EchoRed "debug: RUN QGroundControl CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop: STOP QGroundControl CONTAINER IF IT IS RUNNING"
        EchoRed "run: RUN QGroundControl CONTAINER IN NORMAL MODE"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ] && \
       [ "$2x" != "runx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh $1
            exit 0
        # ACTIONS: debug
        else
            # SET QGC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING QGC_WORKSPACE AS ${QGC_WORKSPACE}"
            sed -i "s~QGC_WORKSPACE=\"\"~QGC_WORKSPACE=${QGC_WORKSPACE}~" ${SITL_ENV_DIR}/qgc.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING QGroundControl CONTAINER IN DEBUG MODE."
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'~g" ${SITL_ENV_DIR}/qgc.env
            elif [ "$2x" == "runx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING QGroundControl CONTAINER IN NORMAL MODE."
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"/usr/local/bin/entrypoint.sh\"\'~g" ${SITL_ENV_DIR}/qgc.env
            fi

            EchoGreen "[$(basename "$0")] RUNNING QGroundControl CONTAINER..."
        fi
    fi
fi

# echo $1
# exit 1

(cd ${SITL_DEPLOY_DIR} && \
docker compose -f ${SITL_DEPLOY_DIR}/compose.yml \
    --env-file ./envs/common.env \
    --env-file ./envs/px4.env \
    --env-file ./envs/gazebo-classic.env \
    --env-file ./envs/airsim.env \
    --env-file ./envs/ros2.env \
    --env-file ./envs/qgc.env \
    --profile $1 up)

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<