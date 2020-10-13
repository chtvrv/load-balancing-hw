build-image:
	docker build -t vapor-service .
start:
	docker-compose up -d
substitute_env_variables:
	sed -i '' -e "s/BLOG_INSTANCE_A/${BLOG_INSTANCE_A}/" Monitoring/prometheus.yml
	sed -i '' -e "s/SYSTEM_INSTANCE_A/${SYSTEM_INSTANCE_A}/" Monitoring/prometheus.yml