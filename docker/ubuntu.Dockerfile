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
    USER_ID=1000 \
    GROUP_ID=0

# Create nonroot user
RUN useradd -ms /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME} && \
    adduser ${USER_NAME} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure ssh
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    mkdir /var/run/sshd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    chown -R ${USER_NAME}:${GROUP_ID} /etc/ssh && \
    mkdir -p ${HOME}/.ssh  && \
    chown -R ${USER_NAME}:${GROUP_ID} /var/run/ && \
    chmod -R 700 /var/run/

# Add SSH key
COPY --chown=${USER_NAME}:${GROUP_ID} \
     --chmod=440 \
     ./resources/id_rsa.pub ${HOME}/.ssh/authorized_keys

USER ${USER_NAME}
WORKDIR ${HOME}

EXPOSE 22 
CMD ["/usr/sbin/sshd", "-D", "-e"]