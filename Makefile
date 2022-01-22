build:
	docker build -t test-server .

up:
	docker-compose up -d

down:
	docker-compose down

ping:
	ansible all -m ping