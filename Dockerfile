##############################################################################
##                                 Base Image                               ##
##############################################################################
ARG ROS_DISTRO=noetic
FROM ros:${ROS_DISTRO}-ros-base
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

##############################################################################
##                                 Global Dependecies                       ##
##############################################################################
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-$ROS_DISTRO-rviz \
    apt-utils \
    nano \
    git \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

##############################################################################
##                                 Create User                              ##
##############################################################################
ARG USER=docker
ARG PASSWORD=docker
ARG UID=1000
ARG GID=1000
ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}
RUN groupadd -g "$GID" "$USER"  && \
    useradd -m -u "$UID" -g "$GID" --shell $(which bash) "$USER" -G sudo && \
    echo "$USER:$PASSWORD" | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudogrp
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
RUN echo "export ROS_MASTER_URI=http://localhost:11311/" >> /home/$USER/.bashrc
# RUN echo "export ROS_IP=<your.ip>" >> /home/$USER/.bashrc

USER $USER 
RUN mkdir -p /home/$USER/ros_ws/src

##############################################################################
##                                 User Dependecies                         ##
##############################################################################
WORKDIR /home/$USER/ros_ws/src

# COPY template_pkg ./template_pkg

# RUN git clone --branch main https://github.com/example/package.git

##############################################################################
##                                 Build ROS and run                        ##
##############################################################################
WORKDIR /home/$USER/ros_ws
RUN . /opt/ros/$ROS_DISTRO/setup.sh && catkin_make
RUN echo "source /home/$USER/ros_ws/devel/setup.bash" >> /home/$USER/.bashrc
RUN echo "export LC_NUMERIC="en_US.UTF-8" " >> ~/.bashrc

RUN sudo sed --in-place --expression \
    '$isource "/home/$USER/ros_ws/devel/setup.bash"' \
    /ros_entrypoint.sh

RUN sudo sed --in-place --expression \
    '$iexport ROS_MASTER_URI=http://localhost:11311/' \
    /ros_entrypoint.sh

# RUN sudo sed --in-place --expression \
#     '$iexport ROS_IP=<your.ip>' \
#     /ros_entrypoint.sh

# CMD ["roslaunch", "template_pkg", "example.launch"]
CMD ["bash"]
