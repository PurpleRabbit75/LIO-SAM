#!/bin/bash

# Generative AI was used to create some portions of this script.

#AB LIO-SAM Installation Script. Installs from https://github.com/TixiaoShan/LIO-SAM/tree/ros2


sudo apt update
sudo apt ugrade
sudo apt autoremove

CWD=$(pwd) #AB store the current directory

if ! [ -d ~/Apps ]; then
    cd ~
    mkdir Apps
fi

cd ~/Apps #AB to to directory ~/Apps, then make and enter ~/Apps/LIO-SAM
mkdir LIO-SAM
cd LIO-SAM

echo "Creating Dockerfile..."

#AB Create a Dockerfile with these contents within ~/Apps/LIO-SAM...
echo 'FROM ros:humble

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_WS=/home/ros2_ws

# Install system dependencies
RUN apt update && apt install -y \
    git \
    wget \
    lsb-release \
    build-essential \
    cmake \
    python3-colcon-common-extensions \
    ros-humble-pcl-conversions \
    ros-humble-pcl-ros \
    ros-humble-tf2-sensor-msgs \
    ros-humble-navigation2 \
    ros-humble-gtsam \
    libgoogle-glog-dev \
    libgflags-dev \
    libyaml-cpp-dev \
    libopencv-dev \
    libboost-all-dev \
    libproj-dev \
    libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/*



# Set up ROS 2 workspace
RUN mkdir -p /home/ros2_ws/src
WORKDIR /home/ros2_ws

# Clone the official LIO-SAM ROS2 fork
RUN git clone https://github.com/TixiaoShan/LIO-SAM.git src/LIO-SAM && \
    cd src/LIO-SAM && \
    git checkout ros2 && \
    git submodule update --init --recursive

# Build the workspace
WORKDIR /home/ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build --symlink-install"

# Automatically source ROS setup and workspace setup on container start
RUN echo '\''source /opt/ros/humble/setup.bash'\'' >> ~/.bashrc && \
    echo '\''source /home/ros2_ws/install/setup.bash'\'' >> ~/.bashrc

# Set default command
CMD ["bash"]' > Dockerfile

echo "Building docker image..."

#AB ...and then compile it using docker build. The docker image can now be launched with docker run.
sudo docker build --no-cache --debug -t lio-sam-humble .

echo "LIO_SAM has finished installing."

cd $CWD #AB Return to the directory the program was in at the start


#AB to run the docker, use sudo docker run -it --rm   --net=host   --privileged   -v ~/Documents/Data:/data   lio-sam-humble



#AB Citations for LIO-SAM and LeGO-LOAM, as requested in the README.md on Github.

# @inproceedings{liosam2020shan,
#   title={LIO-SAM: Tightly-coupled Lidar Inertial Odometry via Smoothing and Mapping},
#   author={Shan, Tixiao and Englot, Brendan and Meyers, Drew and Wang, Wei and Ratti, Carlo and Rus Daniela},
#   booktitle={IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)},
#   pages={5135-5142},
#   year={2020},
#   organization={IEEE}
# }

# @inproceedings{legoloam2018shan,
#   title={LeGO-LOAM: Lightweight and Ground-Optimized Lidar Odometry and Mapping on Variable Terrain},
#   author={Shan, Tixiao and Englot, Brendan},
#   booktitle={IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)},
#   pages={4758-4765},
#   year={2018},
#   organization={IEEE}
# }