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


# MAIN STATEMENTS
# >>>----------------------------------------------------

# CHCEK IF DIRECTORY PX4-Autopilot and build EXISTS
CheckDirExists "PX4-Autopilot"
CheckDirExists "PX4-Autopilot/build"

# CHECK IF PX4-AUTOPILOT IS ALREADY BUILT
CheckDirEmpty "PX4-Autopilot/build"

# CONFIGURE CONNECTION TO QGC
EchoGreen "[$(basename $0)] SETTING CONNECTION TO QGC."
if [ ! -z "${QGC_IP}" ]; then 
    EchoGreen "[$(basename $0)] PX4 WILL BE LISTEN TO THE QGC AT ${QGC_IP}."

    sed -i "s/-x -u \$udp_gcs_port_local/-x -t ${QGC_IP} -u \$udp_gcs_port_local/g" \
        PX4-Autopilot/build/px4_sitl_default/etc/init.d-posix/px4-rc.mavlink
else
    EchoYellow "[$(basename $0)] PX4 WILL BE LISTEN TO THE QGC AT localhost."
fi
EchoGreen $(EchoBoxLine)


# PREVENT GAZEBO FROM RUNNING
EchoGreen "[$(basename $0)] PREVENTING GAZEBO FROM RUNNING."

# BACKUP THE ORIGINAL sitl_run.sh
cp \
    PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_run.sh \
    PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_run.bak

# FIND THE TARGET LINE WITH STRING "$debugger" == "lldb" AND DELETE THE LINE AFTER IT
TARGET_LINE=$(grep -wn 'if \[ "$debugger" == "lldb" \]; then' PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_run.sh | cut -d: -f1)
sed -i "${TARGET_LINE},\$d" PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_run.sh

echo "# MODIFIED NOT TO RUN GAZEBO ON SITL." >> PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_run.sh
echo "# DELETED ALL LINES STARTING FROM ${TARGET_LINE}." >> PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_run.sh

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<