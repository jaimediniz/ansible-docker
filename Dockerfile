FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --upgrade \
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
        zlib1g-dev \
        virtualenv && \
    apt-get clean all

RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    mkdir /var/run/sshd && \
    mkdir /root/.ssh && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

COPY --chmod=400 id_rsa.pub /root/.ssh/authorized_keys
EXPOSE 22 
CMD ["/usr/sbin/sshd", "-D"]