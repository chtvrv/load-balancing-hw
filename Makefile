build-image:
	docker build -t vapor-service .
start:
	docker-compose up -d