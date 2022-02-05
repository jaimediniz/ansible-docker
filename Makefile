remove=command --become

init:
    make install-dependencies  && \
    cd docker && \
    docker-compose build --progress tty && \
    cd .. && \
    make up  && \
    make ping

up:
    docker-compose -f ./docker/docker-compose.yaml up -d

down:
    docker-compose -f ./docker/docker-compose.yaml down 

ping:
    cd ansible && \
    ansible -v all -m ping

command:
    # make command apt-get install docker -- -y --become
    cd ansible && \
    ansible all $(findstring --become, $(MAKECMDGOALS)) -m command -a "$(filter-out $(remove), $(MAKECMDGOALS))"

playbooks:
    cd ansible && \
    ansible-playbook -v ./main.yml

test:
    # make test create-folder
    cd ansible && \
    ansible-playbook -v ./playbooks/$(filter-out test, $(MAKECMDGOALS)).yml

install-dependencies:
    cd ansible && \
    pip install ansible ansible-lint yamllint && \
    ansible-galaxy install -r requirements.yml

lint:
    yamllint . || echo "Lint failed" && \
    cd ansible && \
    ansible-playbook main.yml --syntax-check || echo "Lint failed" && \
    ansible-lint

new-role:
    # make new-role test1
    ansible-galaxy role init --init-path ./ansible/roles $(filter-out new-role, $(MAKECMDGOALS))

%:
    @true