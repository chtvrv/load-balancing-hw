build-image:
	docker build -t vapor-service .
start:
	docker-compose up -d
substitute_env_variables:
	sed -i 's/BLOG_INSTANCE_A/${BLOG_INSTANCE_A}/g' Monitoring/prometheus.yml
	sed -i 's/SYSTEM_INSTANCE_A/${SYSTEM_INSTANCE_A}/g' Monitoring/prometheus.yml