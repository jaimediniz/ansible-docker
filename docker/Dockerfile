FROM ubuntu:20.04

# Install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --upgrade \
        sudo \
        openssh-server \
        pwgen \
        netcat \
        net-tools \
        curl \
        wget \
        build-essential \
        python3 \
        python3-dev \
        python3-pip \
        libxml2-dev \
        libxslt-dev \
        libssl-dev \
        libyaml-dev \
        libffi-dev \
        zlib1g-dev && \
    apt-get clean all

ENV HOME=/home/nonroot \
    USER_NAME=nonroot \
    USER_GROUP=root

# Create nonroot user
RUN useradd -ms /bin/bash -G ${USER_GROUP} ${USER_NAME} && \
    adduser ${USER_NAME} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure ssh
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    mkdir /var/run/sshd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    chown -R ${USER_NAME}:${USER_GROUP} /etc/ssh && \
    mkdir -p ${HOME}/.ssh

# Add SSH key
COPY --chown=${USER_NAME}:${USER_GROUP} \
     --chmod=440 \
     id_rsa.pub ${HOME}/.ssh/authorized_keys

USER ${USER_NAME}
WORKDIR ${HOME}

EXPOSE 22 
CMD ["/usr/sbin/sshd", "-D"]