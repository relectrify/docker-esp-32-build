FROM ubuntu:16.04

# Install build dependencies (and vim for editing)
RUN apt-get -qq update \
    && apt-get install -y \
    git build-essential apt-utils libncurses-dev bison ca-certificates ccache \
    check cmake curl flex gperf lcov libncurses-dev libusb-1.0-0-dev make \
    ninja-build python3 python3-pip unzip wget xz-utils zip language-pack-en vim

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN python -m pip install --upgrade pip virtualenv

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create some directories
RUN mkdir -p /esp
RUN mkdir /esp/esp-idf
RUN mkdir /esp/project
RUN mkdir -p /opt/esp

# Install ESP-IDF	
WORKDIR /esp	
RUN git clone https://github.com/espressif/esp-idf.git	
RUN cd esp-idf && git checkout 99fb9a3f7c28c5fa12b1bd4aa6fb7b622d841326 && git submodule update --init --recursive

# Setup IDF_PATH	
ENV IDF_TOOLS_PATH=/opt/esp
RUN /esp/esp-idf/install.sh
RUN python -m pip install --user -r /esp/esp-idf/requirements.txt

# Add the toolchain binaries to PATH
ENV PATH /opt/esp/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/:opt/esp/python_env/idf4.0_py3.5_env/bin/:$PATH

# This is the directory where our project will show up
WORKDIR /esp/project
