FROM osrf/ros:jazzy-desktop-full

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

RUN echo "deb http://packages.ros.org/ros2-testing/ubuntu $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/ros2-testing.list

ARG  DEBIAN_FRONTEND=noninteractive
ARG  USERNAME=ros
ARG  UID=1000
ARG  GID=1000

RUN apt-get update && apt-get install -y sudo git \
    && (getent group ${GID} && groupmod -n ${USERNAME} $(getent group ${GID} | cut -d: -f1) || addgroup --gid ${GID} ${USERNAME}) \
    && (getent passwd ${UID} && usermod -l ${USERNAME} -d /home/${USERNAME} -m $(getent passwd ${UID} | cut -d: -f1) || adduser --uid ${UID} --gid ${GID} --disabled-password --gecos "" ${USERNAME}) \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && (getent group dialout || addgroup dialout) && usermod -a -G dialout ${USERNAME}

ENV BASE_WS=/home/${USERNAME}/base_ws
RUN mkdir -p ${BASE_WS}/src \
    && chown -R ${USERNAME}:${USERNAME} ${BASE_WS}

ENV BASH_SCRIPTS=/home/${USERNAME}/bash_scripts
RUN mkdir -p ${BASH_SCRIPTS} \
    && chown -R ${USERNAME}:${USERNAME} ${BASH_SCRIPTS}

ENV ROSBAG_DIR=/home/${USERNAME}/rosbags
RUN mkdir -p ${ROSBAG_DIR} \
    && chown -R ${USERNAME}:${USERNAME} ${ROSBAG_DIR}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo git build-essential \
    python3 python3-pip \
    python3-colcon-common-extensions \
    python3-rosdep python3-rosdep-modules && \
    rm -rf /var/lib/apt/lists/*

# 2. Convenience CLI tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nano htop tmux net-tools tree && \
    rm -rf /var/lib/apt/lists/*

# 3. Extra ROS debs used by your workspace
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-jazzy-launch-testing \
    ros-jazzy-tf-transformations \
    ros-jazzy-launch-pytest \
    ros-jazzy-ament-cmake-core \
    libasio-dev \
    ros-jazzy-joy-linux \
    ros-jazzy-rmw-cyclonedds-cpp \
    && \
    rm -rf /var/lib/apt/lists/*

# 4. Deps used for CAN connection
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    iproute2 can-utils && \
    rm -rf /var/lib/apt/lists/*

# 5. Network debugging and optimization tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ethtool iperf3 iputils-ping tcpdump && \
    rm -rf /var/lib/apt/lists/*

# 6. Initialize rosdep (as root before switching user)
RUN rosdep init || true


# 7. Python pip installs
RUN python3 -m pip install --no-cache-dir --break-system-packages \
    tmule==1.5.9 \
    pyserial

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN sed -i 's/^#\(force_color_prompt\)/\1/' /home/${USERNAME}/.bashrc

RUN echo '[ -f $HOME/bash_scripts/bashrc_extensions.sh ] && \
    source $HOME/bash_scripts/bashrc_extensions.sh' \
    >> /home/${USERNAME}/.bashrc


# Set Cyclone DDS as default middleware for better performance
RUN echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> /home/${USERNAME}/.bashrc

CMD ["bin/bash"]
