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

sudo rm -rf /opt/hpcx

# UNSET MPI ENVIRONMENT VARIABLES TO PREVENT BUILD ERRORS
unset OPAL_PREFIX
unset OPENMPI_VERSION
unset OMPI_MCA_coll_hcoll_enable

# UPDATE ROS KEYRING
EchoGreen "[$(basename "$0")] UPDATING ROS KEYRING..."
sudo rm -f /usr/share/keyrings/ros-archive-keyring.gpg
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | \
    sudo gpg --dearmor --batch -o /usr/share/keyrings/ros-archive-keyring.gpg

# INSTALL ADDITIONAL ROS2 PACKAGES
EchoGreen "[$(basename "$0")] INSTALLING ADDITIONAL ROS2 PACKAGES..."
sudo apt-get update
sudo apt-get install -y ros-humble-pcl-ros ros-humble-rmw-cyclonedds-cpp

rosdep update

if [ $# -eq 0 ]; then
    # FOR ALL DIRECTORIES IN ${BASE_DIR}
    # FIND ALL DIRECTORIES WHICH HAS SUBDIRECTORY 'src'
    for dir in $(find ${WORKSPACE_DIR} -maxdepth 1 -mindepth 1 -type d)
    do
        # CASE 1: THE DIRECTORY HAS 'src' SUBDIRECTORY
        if [ -d "${dir}/src" ]; then
            # CHECK IF 'src' DIRECTORY IS EMPTY
            # IF EMPTY, SKIP THE BUILD
            if [ -z "$(ls -A ${dir}/src)" ]; then
                EchoRed "[$(basename "$0")] ${dir}/src IS EMPTY"
                EchoRed "[$(basename "$0")] SKIPPING ${dir}"
            # ELSE, BUILD THE PACKAGES
            else
                EchoGreen "[$(basename "$0")] ${dir} SEEMS TO BE A ROS2 WORKSPACE"
                EchoGreen "[$(basename "$0")] BUILDING PACKAGES INSIDE ${dir}"

                # REMOVE THE PREVIOUS BUILDS
                rm -rf \
                    ${dir}/log \
                    ${dir}/install \
                    ${dir}/build
                
                # INSTALL THE DEPENDENCIES FOR THE PACKAGES
                rosdep install -i --from-paths ${dir}/src --rosdistro ${ROS_DISTRO} -y

                # BUILD THE PACKAGES
                (cd ${dir} || exit 1; colcon build --symlink-install --cmake-args -DBUILD_TESTING=OFF)
                EchoGreen "[$(basename "$0")] BUILD COMPLETED FOR PACKAGES IN ${dir}"
                EchoBoxLine
            fi
        # CASE 2: THE DIRECTORY DOES NOT HAVE 'src' SUBDIRECTORY
        else
            EchoRed "[$(basename "$0")] ${dir} DOES NOT SEEM TO BE A ROS2 WORKSPACE"
        fi
    done
else
    for dir in "${WORKSPACE_DIR}/$@"
    do
        CheckDirExists ${dir}
        CheckDirEmpty ${dir}/src

        EchoGreen "[$(basename "$0")] BUILDING PACKAGES INSIDE ${dir}"

        # REMOVE THE PREVIOUS BUILDS
        rm -rf \
            ${dir}/log \
            ${dir}/install \
            ${dir}/build
        
        export AMENT_PREFIX_PATH=""
        export COLCON_PREFIX_PATH=""
        export CMAKE_PREFIX_PATH=""

        source /opt/ros/${ROS_DISTRO}/setup.bash

        # BUILD THE PACKAGES
        (cd ${dir} || exit 1; colcon build --symlink-install --cmake-args -DBUILD_TESTING=OFF)
        EchoGreen "[$(basename "$0")] BUILD COMPLETED FOR PACKAGES IN ${dir}"
        EchoBoxLine
    done
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
