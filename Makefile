build:
	docker build -t test-server -f ./docker/Dockerfile .

up:
	docker-compose -f ./docker/docker-compose.yaml up -d

down:
	docker-compose -f ./docker/docker-compose.yaml down 

ping:
	ansible all -m ping