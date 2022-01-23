docker-build:
	cd docker && docker build -t test-server . && cd .. || cd ..

docker-test:
	docker run -it test-server /bin/bash

docker-up:
	docker-compose -f ./docker/docker-compose.yaml up -d

docker-down:
	docker-compose -f ./docker/docker-compose.yaml down 

ping:
	cd ansible && ansible all -m ping && cd .. || cd ..

command:
	# make command o="--become" c="apt-get install python3" 
	cd ansible && ansible all $(o) -m command -a "$(c)" && cd .. || cd ..

playbooks:
	cd ansible && ansible-playbook -v ./playbooks.yml && cd .. || cd ..

test:
	cd ansible && ansible-playbook -v ./playbooks/create-folder.yml && cd .. || cd ..