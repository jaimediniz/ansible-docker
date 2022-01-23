remove=command --become

docker-build:
	cd docker
	docker build -t test-server . || cd .. && exit 1
	cd .. 

docker-test:
	docker run -it test-server /bin/bash

up:
	docker-compose -f ./docker/docker-compose.yaml up -d

down:
	docker-compose -f ./docker/docker-compose.yaml down 

ping:
	cd ansible
	ansible all -m ping || cd .. && exit 1
	cd ..

command:
	# make command apt-get install docker -- -y --become
	cd ansible && ansible all $(findstring --become, $(MAKECMDGOALS)) -m command -a "$(filter-out $(remove), $(MAKECMDGOALS))" && cd .. || cd ..

playbooks:
	cd ansible
	ansible-playbook -v ./playbooks.yml || cd .. && exit 1
	cd .. 

test:
	# make test create-folder
	cd ansible
	ansible-playbook -v ./playbooks/$(filter-out test, $(MAKECMDGOALS)).yml || cd .. && exit 1
	cd ..

install-dependencies:
	cd ansible
	#ansible-galaxy collection install community.sops || cd .. && exit 1
	cd .. 

%:
	@true