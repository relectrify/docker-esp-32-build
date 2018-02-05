FROM ubuntu:14.04

# Install build dependencies (and vim + picocom for editing/debugging)
RUN apt-get -qq update \
    && apt-get install -y git wget make libncurses-dev flex bison gperf python python-serial vim picocom \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create some directories
RUN mkdir -p /esp
RUN mkdir /esp/esp-idf
RUN mkdir /esp/project

# Get the ESP32 toolchain and extract it to /esp/xtensa-esp32-elf
RUN wget -O /esp/esp-32-toolchain.tar.gz https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-75-gbaf03c2-5.2.0.tar.gz \
    && tar -xzf /esp/esp-32-toolchain.tar.gz -C /esp \
    && rm /esp/esp-32-toolchain.tar.gz
    

# Install ESP-IDF
RUN git clone --recursive https://github.com/espressif/esp-idf.git
WORKDIR /esp/esp-idf
RUN git checkout -b v3.0 origin/release/v3.0
RUN git submodule update

# Add the toolchain binaries to PATH
ENV PATH /esp/xtensa-esp32-elf/bin:$PATH

# Setup IDF_PATH
ENV IDF_PATH /esp/esp-idf

# This is the directory where our project will show up
WORKDIR /esp/project
