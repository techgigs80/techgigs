FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
LABEL maintainer "lucas.ku <kyungho.ku@poscoict.com>"

ENV CUDNN_VERSION 7.6.4.38
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

ARG DEBIAN_FRONTEND=noninteractive

COPY posco_ict_sha_256_encryted.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

RUN apt-get update --fix-missing && apt-get upgrade -y \
        && apt-get install -y openssh-server unzip curl vim\
        && mkdir --mode 700 /var/run/sshd

RUN echo 'root:q1w2e3r4!' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]