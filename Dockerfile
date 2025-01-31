FROM osrf/ros:humble-desktop
ARG USERNAME=ROSCARLA
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBIAN_FRONTEND=noninteractive

ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV NVIDIA_VISIBLE_DEVICES=all

ENV DOCKER_RUNNING=true

# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \ 
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip

#Carla dependecies
RUN apt-get install -y \
    pciutils \
    vulkan-tools \
    mesa-utils \
    libxext6 \
    libvulkan1 \
    libvulkan-dev \
    vulkan-tools \
    libsdl2-2.0 \
    libomp5 \
    xdg-user-dirs \
    xdg-utils 

# Python3.7 install
RUN sudo apt install -y software-properties-common
RUN sudo add-apt-repository -y ppa:deadsnakes/ppa 
RUN sudo apt update 
RUN sudo apt install -y python3.7 python3.7-distutils

COPY CARLA_0.9.15 /home/CARLA_0.9.15
RUN chown $USERNAME:$USERNAME /home/CARLA_0.9.15
WORKDIR /home/CARLA_0.9.15/PythonAPI/examples
RUN python3.7 -m pip install carla 
RUN python3.7 -m pip install -r requirements.txt
RUN ln -s /usr/bin/python3.7 /usr/bin/python

USER $USERNAME
CMD ["/bin/bash"]