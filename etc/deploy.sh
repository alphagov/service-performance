#!/usr/bin/env bash

set -e

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker build --file=$DOCKER_FILE --tag=$DOCKER_REPOSITORY/$DOCKER_IMAGE:$TRAVIS_BUILD_NUMBER .
docker push $DOCKER_REPOSITORY/$DOCKER_IMAGE:$TRAVIS_BUILD_NUMBER
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update && sudo apt-get install cf-cli
cf login -u $PAAS_USER -p $PAAS_PASSWORD -a https://api.cloud.service.gov.uk -o cross-government-service-data -s staging
cf push $PAAS_SERVICE --docker-image $DOCKER_REPOSITORY/$DOCKER_IMAGE:$TRAVIS_BUILD_NUMBER