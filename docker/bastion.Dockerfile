FROM alpine:3.11.6

ENV HOME=/home/nonroot \
    USER_NAME=nonroot \
    USER_ID=1000 \
    GROUP_ID=0 \
    GROUP=root

RUN adduser -D -h ${HOME} -s /bin/ash -g "${USER_NAME} service" \
        -u ${USER_ID} -G ${GROUP} ${USER_NAME} && \
    sed -i "s/${USER_NAME}:!/${USER_NAME}:*/g" /etc/shadow && \
    apk add --no-cache \
        openssh-server && \
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

# Add bastion script
COPY --chown=${USER_NAME}:${GROUP_ID} \
     --chmod=755 \
     ./resources/bastion /usr/sbin/bastion

# Add SSH key
COPY --chown=${USER_NAME}:${GROUP_ID} \
     --chmod=440 \
     ./resources/id_rsa.pub ${HOME}/.ssh/authorized_keys

EXPOSE 22/tcp
ENTRYPOINT ["bastion"]