# Ansible Local Test

## Requirements

1. Python
1. Pip
1. Docker

## Steps

1. Replace ./docker/resources/id_rsa.pub key
1. `make init`

## Containers

1. Ubuntu 20.04
    - ubuntu1.test
1. Centos 8
    - centos1.test
1. Alpine 3.11.6
    - bastion

### Network

There are two networks connecting the containers
- private
- bastion

The host machine uses the bastion network to the bastion, and it uses the bastion as proxy to connect to the other containers in the private network.

## Reference:

- https://davidcarrascal.medium.com/a-simple-ansible-playground-using-docker-eeb458cbba32
- https://www.youtube.com/watch?v=goclfp6a2IQ
- https://github.com/geerlingguy/ansible-role-java
