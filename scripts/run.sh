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
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
elif [ "$1x" == "gazebo-classic-airsim-sitlx" ]; then
    EchoRed "[$(basename "$0")] NOT IMPLEMENTED YET"
    exit 1
elif [ "$1x" == "px4x" ]; then
    # SECOND ARGUMENTS: debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 px4 [clone|debug|stop]"
        EchoRed "clone: CLONE PX4-AUTOPILOT REPOSITORY"
        EchoRed "debug: RUN PX4-AUTOPILOT CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP PX4-AUTOPILOT CONTAINER IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "clonex" ] && \
       [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh px4
            exit 0
        # ACTIONS: debug
        else
            # SET PX4_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING PX4_WORKSPACE AS ${PX4_WORKSPACE}"
            sed -i "s~PX4_WORKSPACE=\"\"~PX4_WORKSPACE=${PX4_WORKSPACE}~" ${SITL_ENV_DIR}/px4.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER IN DEBUG MODE."
                sed -i "s/PX4_RUN_COMMAND=\"\"/PX4_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/px4.env
            elif [ "$2x" == "clonex" ]; then
                EchoGreen "[$(basename "$0")] CLONE PX4-AUTOPILOT REPOSITORY TO THE PX4_WORKSPACE"
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE PROCESS"

                # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
                cp ${BASE_DIR}/px4/clone.sh ${PX4_WORKSPACE}/clone.sh
                cp -r ${BASE_DIR}/include ${PX4_WORKSPACE}

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~PX4_RUN_COMMAND=\"\"~PX4_RUN_COMMAND=\'bash -c \"/home/user/workspace/clone.sh\"\'~g" ${SITL_ENV_DIR}/px4.env                
            fi

            EchoGreen "[$(basename "$0")] RUNNING PX4-AUTOPILOT CONTAINER..."
        fi
    fi

elif [ "$1x" == "gazebo-classicx" ]; then
    # SECOND ARGUMENTS: debug, stop
    usageState2(){
        EchoRed "INVALID INPUT \"$1\". PLEASE USE ARGUMENT AS FOLLOWING:"
        EchoRed "Usage: $0 gazebo-classic [rdebug]"
        EchoRed "debug: RUN GAZEBO-CLASSIC CONTAINER IN DEBUG MODE (sleep infinity)"
        EchoRed "stop:  STOP GAZEBO-CLASSIC CONTAINER IF IT IS RUNNING"
        exit 1
    }

    # SECOND ARGUMENT CHECK: debug, stop
    if [ "$2x" != "debugx" ] && \
       [ "$2x" != "stopx" ]; then
        usageState2 $2
        exit 1
    else
        # ACTION: stop. STOP THE CONTAINER
        if [ "$2x" == "stopx" ]; then
            EchoYellow "[$(basename "$0")] THIS FEATURE IS FOR CONVENIENCE."
            EchoYellow "[$(basename "$0")] IT IS RECOMMENDED TO USE stop.sh SCRIPT TO STOP THE CONTAINER."
            ${BASE_DIR}/stop.sh gazebo-classic
            exit 0
        # ACTIONS: debug
        else
            # SET GAZEBO_CLASSIC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING GAZEBO_CLASSIC_WORKSPACE AS ${GAZEBO_CLASSIC_WORKSPACE}"
            sed -i "s~GAZEBO_CLASSIC_WORKSPACE=\"\"~GAZEBO_CLASSIC_WORKSPACE=${GAZEBO_CLASSIC_WORKSPACE}~" ${SITL_ENV_DIR}/gazebo-classic.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING GAZEBO-CLASSIC CONTAINER IN DEBUG MODE."
                sed -i "s/GAZEBO_CLASSIC_RUN_COMMAND=\"\"/GAZEBO_CLASSIC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/gazebo-classic.env
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
            ${BASE_DIR}/stop.sh airsim
            exit 0
        # ACTIONS: debug, auto, *.sh
        else
            # set AIRSIM_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING AIRSIM_WORKSPACE AS ${AIRSIM_WORKSPACE}"
            sed -i "s~AIRSIM_WORKSPACE=\"\"~AIRSIM_WORKSPACE=${AIRSIM_WORKSPACE}~" ${SITL_ENV_DIR}/airsim.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN DEBUG MODE."
                sed -i "s/AIRSIM_RUN_COMMAND=\"\"/AIRSIM_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/airsim.env
            # ACTION: auto. RUN THE CONTAINER IN AUTO MODE (run .sh file in /home/ue4/workspace/binary)
            elif [ "$2x" == "autox" ]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER IN AUTO MODE."
                EchoGreen "[$(basename "$0")] AIRSIM CONTAINER WILL FIND AND RUN .sh FILE IN /home/ue4/workspace/binary DIRECTORY."

                cp ${BASE_DIR}/airsim/auto.sh ${AIRSIM_WORKSPACE}/auto.sh
                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/auto.sh\"\'~g" ${SITL_ENV_DIR}/airsim.env
            # ACTION: *.sh. RUN THE CONTAINER IN MANUAL MODE (run specific .sh file)
            elif [[ "$2x" == *".shx" ]]; then
                EchoGreen "[$(basename "$0")] RUNNING AIRSIM CONTAINER WITH $2"

                CheckFileExists ${AIRSIM_DEPLOY_DIR}/$2
                CheckFileExecutable ${AIRSIM_DEPLOY_DIR}/$2

                sed -i "s~AIRSIM_RUN_COMMAND=\"\"~AIRSIM_RUN_COMMAND=\'bash -c \"/home/ue4/workspace/$2\"\'~g" ${SITL_ENV_DIR}/airsim.env
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
            ${BASE_DIR}/stop.sh ros2
            exit 0
        # ACTIONS: debug, build, *.sh
        else
            # SET ROS2_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING ROS2_WORKSPACE AS ${ROS2_WORKSPACE}"
            sed -i "s~ROS2_WORKSPACE=\"\"~ROS2_WORKSPACE=${ROS2_WORKSPACE}~" ${SITL_ENV_DIR}/ros2.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER IN DEBUG MODE."
                sed -i "s/ROS2_RUN_COMMAND=\"\"/ROS2_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/ros2.env
            # ACTION: build. BUILD ROS2 PACKAGES INSIDE THE CONTAINER
            elif [ "$2x" == "buildx" ]; then
                EchoGreen "[$(basename "$0")] BUILDING ROS2 PACKAGES INSIDE THE CONTAINER."
                EchoGreen "[$(basename "$0")] CONTAINER WILL BE STOPPED AFTER THE BUILD PROCESS."

                # COPY BUILD SCRIPT AND FUNCTION DEFINITIONS
                cp ${BASE_DIR}/ros2/build.sh ${ROS2_WORKSPACE}/build.sh
                cp -r ${BASE_DIR}/include ${ROS2_WORKSPACE}

                # IF ADDITIONAL DIRECTORIES ARE PROVIDED, PASS THEM TO THE BUILD SCRIPT
                if [ $# -ge 3 ]; then
                    # DUE TO SED ESCAPE ISSUE, ADDITIONAL ENVIRONMENT VARIABLE IS SET
                    TARGET_ROS2_WORKSPACES=${@:3}
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/build.sh ${TARGET_ROS2_WORKSPACES}\"\'~g" ${SITL_ENV_DIR}/ros2.env
                # ELSE, RUN THE BUILD SCRIPT. THIS WILL BUILD ALL PACKAGES IN THE ALL DIRECTORIES THAT HAVE NON-EMPTY 'src' SUBDIRECTORY
                else
                    sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/build.sh\"\'~g" ${SITL_ENV_DIR}/ros2.env
                fi 
            # ACTION: *.sh. RUN THE CONTAINER IN MANUAL MODE (RUN SPECIFIC SHELL SCRIPT)
            elif [[ "$2x" == *".shx" ]]; then
                EchoGreen "[$(basename "$0")] RUNNING ROS2 CONTAINER WITH $2"

                # CHECK IF THE SCRIPT EXISTS AND EXECUTABLE
                CheckFileExists ${ROS2_WORKSPACE}/$2
                CheckFileExecutable ${ROS2_WORKSPACE}/$2

                # SET THE RUN COMMAND TO THE .env FILE
                sed -i "s~ROS2_RUN_COMMAND=\"\"~ROS2_RUN_COMMAND=\'bash -c \"/home/user/workspace/$2\"\'~g" ${SITL_ENV_DIR}/ros2.env
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
            ${BASE_DIR}/stop.sh qgc
            exit 0
        # ACTIONS: debug
        else
            # SET QGC_WORKSPACE TO THE .env FILE
            EchoGreen "[$(basename "$0")] SETTING QGC_WORKSPACE AS ${QGC_WORKSPACE}"
            sed -i "s~QGC_WORKSPACE=\"\"~QGC_WORKSPACE=${QGC_WORKSPACE}~" ${SITL_ENV_DIR}/qgc.env

            # ACTION: debug. RUN THE CONTAINER IN DEBUG MODE (sleep infinity)
            if [ "$2x" == "debugx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING QGroundControl CONTAINER IN DEBUG MODE."
                sed -i "s/QGC_RUN_COMMAND=\"\"/QGC_RUN_COMMAND=\'bash -c \"sleep infinity\"\'/g" ${SITL_ENV_DIR}/qgc.env
            elif [ "$2x" == "runx" ]; then
                EchoGreen "[$(basename "$0")] RUNNING QGroundControl CONTAINER IN NORMAL MODE."
                sed -i "s~QGC_RUN_COMMAND=\"\"~QGC_RUN_COMMAND=\'bash -c \"/usr/local/bin/entrypoint.sh\"\'~g" ${SITL_ENV_DIR}/qgc.env
            fi

            EchoGreen "[$(basename "$0")] RUNNING QGroundControl CONTAINER..."
        fi
    fi
fi

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