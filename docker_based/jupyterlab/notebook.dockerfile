# Copyright (c) lucas.ku(ruria80@gmail.com)
# Distributed under the terms of the Modified BSD License.

# nvidia/cuda tag from https://hub.docker.com/r/nvidia/cuda/
# e.g. nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ARG BASE_TAG=9.0-cudnn7-devel-ubuntu16.04
FROM nvidia/cuda:${BASE_TAG}

LABEL maintainer="personal jupyter lab <ruria80@gmail.com>"

# Configurable the value for your usages
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

USER root

# Install the necessary os packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    software-properties-common \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    apt-utils \
    vim

# Install python3 and upgrade pip
RUN add-apt-repository ppa:jonathonf/python-3.6 \
 && apt-get update --fix-missing \
 && apt-get install -yq build-essential python3.6 python3.6-dev python3-pip python3.6-venv \
 && rm -rf /var/lib/apt/lists/*

RUN python3.6 -m pip install pip --upgrade \
 && rm -rf /usr/bin/python3 \
 && ln -s /usr/bin/python3.6 /usr/bin/python

## Setting up locale and create the non-root user
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PASSWORD="q1w2e3r4!" \
    BINDING="0.0.0.0" \
    WORK_FOLDER="\/home\/${NB_USER}\/work"
ENV HOME=/home/${NB_USER}

# Add a script that we will use to correct permissions after running certain commands
ADD fix-permissions /usr/local/bin/fix-permissions

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create NB_USER wtih name roki user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd && \
    echo "${NB_USER}    ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NB_USER && \
    chmod 0440 /etc/sudoers.d/$NB_USER && \
    fix-permissions ${HOME}

USER ${NB_UID}

RUN mkdir /home/${NB_USER}/work && \
    mkdir -p /home/${NB_USER}/.config/pip && \
    echo "[global]" > /home/${NB_USER}/.config/pip/pip.conf && \
    echo "no-cache-dir=false" >> /home/${NB_USER}/.config/pip/pip.conf && \
    fix-permissions /home/${NB_USER}

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN sudo chmod +x /usr/bin/tini

## Build the virtualenv for python3
RUN sudo -H pip install virtualenv virtualenvwrapper jupyterlab seaborn && \
    echo "export PATH=/home/${NB_USER}/.local/bin:${PATH}" \
    echo "export EDITOR=vim" >> ${HOME}/.bashrc && \
    echo "export CUDA_HOME=/usr/local/cuda" >> ${HOME}/.bashrc && \
    echo "export WORKON_HOME=/home/${NB_USER}/.virtualenvs" >> ${HOME}/.bashrc && \
    echo ". /usr/local/bin/virtualenvwrapper.sh" >> ${HOME}/.bashrc && \
    fix-permissions ${HOME}

RUN jupyter notebook --generate-config && \
    sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '$BINDING'/g" /home/${NB_USER}/.jupyter/jupyter_notebook_config.py && \
    sed -i "s/#c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '$WORK_FOLDER'/g" /home/${NB_USER}/.jupyter/jupyter_notebook_config.py && \
    sed -i "s/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" /home/${NB_USER}/.jupyter/jupyter_notebook_config.py && \
    fix-permissions /home/${NB_USER}

USER root

EXPOSE 6006 8888
WORKDIR ${HOME}

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
RUN fix-permissions ${HOME}

USER $NB_UID
