# Copyright (c) lucas.ku(ruria80@gmail.com)
# Distributed under the terms of the Modified BSD License.

# nvidia/cuda tag from https://hub.docker.com/r/nvidia/cuda/tags
# e.g. nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG BASE_TAG=10.1-cudnn7-devel-ubuntu18.04
FROM nvidia/cuda:${BASE_TAG}

LABEL maintainer="lucas.ku <ruria80@gmail.com>"

# Configurable the value for your usages
ARG NB_USER="lucas"
ARG NB_UID="1000"
ARG NB_GID="10000"
ARG PASSWORD="q1w2e3r4!"

USER root

# Install the necessary os packages
ENV DEBIAN_FRONTEND noninteractive

COPY posco_ict_sha_256_encryted.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
RUN apt-get update \
    && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
                software-properties-common wget \
                bzip2 ca-certificates \
                sudo locales fonts-liberation \
                build-essential python3-dev python3-pip python3-setuptools \
                net-tools vim \
    && rm -rf /var/lib/apt/lists/*

## make useful symbolic link
RUN ln -s /usr/bin/python3.6 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && python -m pip install  --upgrade pip

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
    PASSWORD=${PASSWORD} \
    BINDING="0.0.0.0" \
    WORK_FOLDER="\/home\/${NB_USER}\/workspace"
ENV HOME=/home/${NB_USER}

RUN echo 'root:${PASSWORD}' |chpasswd

# Add a script that we will use to correct permissions after running certain commands
ADD fix-permissions /usr/local/bin/fix-permissions

RUN groupadd -g 10000 researchers

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create NB_USER wtih name sysadmin user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers \
    && sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers \
    && useradd -m -s /bin/bash -N -u $NB_UID -g $NB_GID $NB_USER \
    && RUN echo '${NB_USER}:${PASSWORD}' | chpasswd \
    && chmod g+w /etc/passwd \
    && echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && fix-permissions ${HOME}

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini


USER ${NB_UID}

RUN mkdir /home/${NB_USER}/workspace \
    && mkdir -p /home/${NB_USER}/.config/pip \
    && echo "[global]" > /home/${NB_USER}/.config/pip/pip.conf \
    && echo "no-cache-dir=false" >> /home/${NB_USER}/.config/pip/pip.conf \
    && fix-permissions /home/${NB_USER}

## Build the virtualenv for python3
RUN sudo -H pip install virtualenv virtualenvwrapper jupyterlab seaborn tqdm\
    && echo "export PATH=/home/${NB_USER}/.local/bin:${PATH}" \
    && echo "export EDITOR=vim" >> ${HOME}/.bashrc \
    && echo "export CUDA_HOME=/usr/local/cuda" >> ${HOME}/.bashrc \
    && echo "export WORKON_HOME=/home/${NB_USER}/.virtualenvs" >> ${HOME}/.bashrc \
    && echo ". /usr/local/bin/virtualenvwrapper.sh" >> ${HOME}/.bashrc \
    && fix-permissions ${HOME}

RUN jupyter notebook --generate-config \
    && sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '$BINDING'/g" /home/${NB_USER}/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '$WORK_FOLDER'/g" /home/${NB_USER}/.jupyter/jupyter_notebook_config.py \
    && sed -i "s/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" /home/${NB_USER}/.jupyter/jupyter_notebook_config.py \
    && fix-permissions /home/${NB_USER}

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