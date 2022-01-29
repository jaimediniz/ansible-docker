remove=command --become

docker-build:
	cd docker && \
	docker build -t test-server .

up:
	docker-compose -f ./docker/docker-compose.yaml up -d

down:
	docker-compose -f ./docker/docker-compose.yaml down 

ping:
	cd ansible && \
	ansible all -m ping

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
	ansible-galaxy collection install community.sops
	pip install ansible-lint

lint:
	cd ansible && \
	ansible-lint

%:
	@true