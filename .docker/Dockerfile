FROM osrf/ros:noetic-desktop-full

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libpoco-dev \
    python3-catkin-tools \
    python3-osrf-pycommon \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/libfranka
RUN git clone --recursive --branch 0.9.1 https://github.com/frankarobotics/libfranka.git . \
    && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF .. \
    && make -j$(nproc) \
    && make install

WORKDIR /catkin_ws
RUN mkdir -p src \
    && cd src \
    && git clone --branch 0.9.1 https://github.com/frankarobotics/franka_ros.git

RUN apt-get update \
    && rosdep update --include-eol-distros \
    && rosdep install --from-paths src --ignore-src -y --skip-keys libfranka \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin build -DCMAKE_BUILD_TYPE=Release"

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc \
    && echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

CMD ["bash"]
