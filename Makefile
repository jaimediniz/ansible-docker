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
	ansible -vv all -m ping
