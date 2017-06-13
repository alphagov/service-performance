IMAGE_NAME:=leelongmore/cgsd-api-rails-ci

docker-build-ci:
		docker build --file=etc/cgsd-api-rails-ci.df --tag=${IMAGE_NAME} .
		docker login
		docker push ${IMAGE_NAME}

docker-run-tests:
		docker pull ${IMAGE_NAME}
		docker run --volume=$(shell pwd):/app -it ${IMAGE_NAME} /bin/sh -c "bundle && bundle exec rake"
