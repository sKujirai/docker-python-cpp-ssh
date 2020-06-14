# Kaggle image
FROM gcr.io/kaggle-gpu-images/python:v79

ARG EIGEN_VERSION=3.3.7
ARG BOOST_VERSION=boost-1.70.0
ARG SPDLOG_VERSION=v1.3.1
ARG TMP_WORK_DIR="/tmp_work"

RUN apt-get update \
    && apt-get autoremove -y \
    && apt-get -y upgrade

# Overwrite sh with bash
RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh

# C++
RUN apt-get install -y --fix-broken --fix-missing sudo git build-essential cmake valgrind gdb emacs vim wget ftp ncftp doxygen graphviz software-properties-common

# Make temp dir
RUN mkdir ${TMP_WORK_DIR}

# Eigen
RUN cd ${TMP_WORK_DIR} \
    && git clone https://github.com/eigenteam/eigen-git-mirror.git \
    && cd ${TMP_WORK_DIR}/eigen-git-mirror \
    && git checkout ${EIGEN_VERSION} \
    && cd ${TMP_WORK_DIR} \
    && mv ${TMP_WORK_DIR}/eigen-git-mirror /opt/ \
    && ln -s /opt/eigen-git-mirror/Eigen/ /usr/local/include/Eigen \
    && ln -s /opt/eigen-git-mirror/unsupported/ /usr/local/include/unsupported

# Boost
RUN cd ${TMP_WORK_DIR} \
    && git clone https://github.com/boostorg/boost.git \
    && cd ${TMP_WORK_DIR}/boost \
    && git checkout ${BOOST_VERSION} \
    && git submodule update --init --recursive \
    && ./bootstrap.sh \
    && ./b2 install -j2 --prefix=/usr/local; exit 0

# spdlog
RUN cd ${TMP_WORK_DIR} \
    && git clone https://github.com/gabime/spdlog.git \
    && cd ${TMP_WORK_DIR}/spdlog \
    && git checkout ${SPDLOG_VERSION} \
    && cd ${TMP_WORK_DIR} \
    && mv ${TMP_WORK_DIR}/spdlog /opt/ \
    && ln -s /opt/spdlog/include/spdlog/ /usr/local/include/spdlog

# Remove tmp dir
RUN rm -rf ${TMP_WORK_DIR}

# Set environmental variable
RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

# Restore sh
RUN rm /bin/sh && mv /bin/sh_tmp /bin/sh

# SSH
RUN apt-get install -y openssh-server

RUN if [ ! -e .ssh ]; then mkdir  ~/.ssh; fi \
    && if [ ! -e .ssh/authorized_keys ]; then touch  ~/.ssh/authorized_keys; fi \
    && chmod 600  ~/.ssh/authorized_keys

SHELL ["/bin/bash", "-l", "-c"]
