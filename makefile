IMAGE_NAME_CI:=gsddeploy/gsd-api-ci:latest

docker-build-ci:
	docker login -u gsddeploy
	docker build --file=etc/gsd-api-ci.df --tag=${IMAGE_NAME_CI} .
	docker push ${IMAGE_NAME_CI}

docker-test-ci:
	docker run -d --rm --name=postgres-api-test postgres:9.6.3-alpine
	docker run -it --rm --link=postgres-api-test:postgres --volume=$(shell pwd):/app ${IMAGE_NAME_CI} /bin/sh -c "cp /app/config/database.yml.travis /app/config/database.yml && bundle config build.nokogiri --use-system-libraries && bundle --without development production && bundle exec rake db:test:prepare && bundle exec rspec spec"
	docker container rm postgres-api-test --force
