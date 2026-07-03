# builder copied from taskwarrior git repo
FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
            build-essential \
            cmake \
            curl \
            git \
            libgnutls28-dev \
            uuid-dev

# Setup language environment
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add source directory
# use git clone https://github.com/GothenburgBitFactory/taskwarrior.git to make use of caching
# ADD . /root/code/
RUN git clone https://github.com/GothenburgBitFactory/taskwarrior.git /root/code
WORKDIR /root/code/

# Setup Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh && \
    sh rustup.sh -y --profile minimal --default-toolchain stable --component rust-docs

# Build Taskwarrior
RUN git clean -dfx && \
    git submodule init && \
    git submodule update && \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release . && \
    cmake --build build -j 8

FROM python:slim

# TODO adjust if no caldav is used
RUN pip install "syncall[caldav,tw]"

ENV USER=synctw
# add user and install cron (and a logging handler for python logging issues) and set sticky (to use with non root)
RUN adduser --disabled-password --gecos "" $USER && \
    apt-get update && apt-get install -y cron && chmod u+s /usr/sbin/cron

# Install Taskwarrior
COPY --from=builder /root/code/build/src/task /usr/local/bin/

# hacky workaround to create symlink in /dev on startup as root user and fake syslog behaviour to
# make syncall work without errors in docker container in combination with python mocking script
# since it uses syslog without a way to disable it
RUN echo "@reboot ln -sf /tmp/devlog /dev/log" > link-fix && crontab link-fix

# switch user and set workdir to user home
USER $USER
WORKDIR /home/$USER

COPY --chown=$USER:$USER ./scripts/ .

# update crontab and initialize task(rc) and disable confirmation for script
# + hack to not show news info
RUN crontab -u $USER cron-task && echo "confirmation=off\nnews.version=9.9.9" > .taskrc

CMD sh start.sh
