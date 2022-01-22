build:
	cd docker && docker build -t test-server . && cd .. || cd ..

test:
	docker run -it test-server /bin/bash

up:
	docker-compose -f ./docker/docker-compose.yaml up -d

down:
	docker-compose -f ./docker/docker-compose.yaml down 

ping:
	cd ansible && ansible all -m ping && cd .. || cd ..

playbook:
	cd ansible && ansible-playbook -v ./playbooks/main.yml && cd .. || cd ..