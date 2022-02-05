FROM centos:8

# Install packages
RUN yum update \
    yum install -y \
        curl \
        wget \
        build-essential \
        python3 \
        python3-dev \
        python3-pip

ENV HOME=/home/nonroot \
    USER_NAME=nonroot \
    USER_ID=1000 \
    GROUP_ID=0

# Create nonroot user
RUN useradd -ms /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME} && \
    usermod -aG wheel ${USER_NAME} && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Add ssh server. This needs to be in a seperated layer.
RUN yum install -y \
        openssh-clients \
        openssh-server \
        sudo

# Configure ssh
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    chown -R ${USER_NAME}:${GROUP_ID} /etc/ssh && \
    chmod -R 600 \
        /etc/ssh/ssh_host_rsa_key \
        /etc/ssh/ssh_host_dsa_key \
        /etc/ssh/ssh_host_ecdsa_key \
        /etc/ssh/ssh_host_ed25519_key && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    mkdir /var/run/sshd && \
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