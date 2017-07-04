IMAGE_NAME_CI:=gsddeploy/gsd-view-data-ci:latest

docker-build-ci:
	docker login -u gsddeploy
	docker build --file=etc/gsd-view-data-ci.df --tag=${IMAGE_NAME_CI} .
	docker push ${IMAGE_NAME_CI}

docker-test-ci:
	docker run -it --rm --volume=$(shell pwd):/app ${IMAGE_NAME_CI} /bin/sh -c "cp /app/.env.example /app/.env && bundle config build.nokogiri --use-system-libraries && bundle --without development production && bundle exec rspec spec"
