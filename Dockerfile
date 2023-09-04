FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository universe

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

ENV ROS_DISTRO foxy
ENV CUDA_TOOLKIT_DIR /usr/local/cuda-11.4

RUN apt-get update && apt-get install -y --no-install-recommends \
  ros-foxy-ros-core python3-argcomplete \
  ros-dev-tools \
  && rm -rf /var/lib/apt/lists/*

COPY ./ros_entrypoint.sh .
RUN chmod +x ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
