FROM nvidia/cuda:11.3.0-runtime-ubuntu20.04
WORKDIR /workspace

WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

# change apt source
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY installers /tmp/installers
COPY skel /tmp/skel
RUN bash /tmp/installers/install_skel.sh
RUN bash /tmp/installers/install_ssh.sh
RUN python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY NotoSerifCJK-Regular.ttc /usr/share/fonts/NotoSerifCJK-Regular.ttc

RUN fc-cache -vf

# python, dependencies for mujoco-py, from https://github.com/openai/mujoco-py
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locale \
    python3-pip \
    build-essential \
    patchelf \
    curl \
    git \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    software-properties-common \
    net-tools \
    vim \
    virtualenv \
    wget \
    xpra \
    xserver-xorg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

RUN ln -s /usr/bin/python3 /usr/bin/python
# installing mujoco distr
RUN mkdir -p /root/.mujoco \
    && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz \
    && tar -xf mujoco.tar.gz -C /root/.mujoco \
    && rm mujoco.tar.gz
ENV LD_LIBRARY_PATH /root/.mujoco/mujoco210/bin:${LD_LIBRARY_PATH}

# installing poetry & env setup, mujoco_py compilation
COPY requirements/requirements.txt requirements.txt
# RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
# RUN python -c "import mujoco_py"

# COPY . /workspace/CORL/
