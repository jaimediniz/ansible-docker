build:
	cd docker && docker build -t test-server . && cd .. || cd ..

up:
	docker-compose -f ./docker/docker-compose.yaml up -d

down:
	docker-compose -f ./docker/docker-compose.yaml down 

ping:
	cd ansible && ansible all -m ping && cd .. || cd ..

playbook:
	cd ansible && ansible-playbook ./playbooks/install.yml && cd .. || cd ..