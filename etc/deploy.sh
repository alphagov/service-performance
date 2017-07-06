#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Missing PAAS space argument"
    echo "  deploy.sh staging|production"
    exit 1
fi

PAAS_SPACE=$1
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker build --file=$DOCKER_FILE --tag=$DOCKER_REPOSITORY/$DOCKER_IMAGE:$TRAVIS_BUILD_NUMBER .
docker push $DOCKER_REPOSITORY/$DOCKER_IMAGE:$TRAVIS_BUILD_NUMBER
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update && sudo apt-get install cf-cli
cf login -u $PAAS_USER -p $PAAS_PASSWORD -a https://api.cloud.service.gov.uk -o cross-government-service-data -s $PAAS_SPACE
cf set-env $PAAS_SERVICE API_URL $APP_API_URL
cf set-env $PAAS_SERVICE API_USERNAME $APP_API_USERNAME
cf set-env $PAAS_SERVICE API_PASSWORD $APP_API_PASSWORD
cf set-env $PAAS_SERVICE SECRET_KEY_BASE $APP_SECRET_KEY_BASE
cf push $PAAS_SERVICE --docker-image $DOCKER_REPOSITORY/$DOCKER_IMAGE:$TRAVIS_BUILD_NUMBER
