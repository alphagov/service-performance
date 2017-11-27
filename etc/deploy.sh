#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Missing PAAS space argument"
    echo "  deploy.sh staging|production"
    exit 1
fi

PAAS_SPACE=$1

wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf-cli

cf login -u $PAAS_USERNAME -p $PAAS_PASSWORD -a https://api.cloud.service.gov.uk -o government-service-data -s $PAAS_SPACE
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin -f blue-green-deploy -r CF-Community

cf set-env service-performance-$PAAS_SPACE SECRET_KEY_BASE $SECRET_KEY_BASE
cf set-env service-performance-$PAAS_SPACE TAG_MANAGER_ID $TAG_MANAGER_ID
cf set-env service-performance-$PAAS_SPACE-new SECRET_KEY_BASE $SECRET_KEY_BASE

cf blue-green-deploy service-performance-$PAAS_SPACE
cf map-route service-performance-staging  cloudapps.digital  --hostname gsd-api
cf map-route service-performance-staging  cloudapps.digital  --hostname gsd-view-data
cf map-route service-performance-staging  cloudapps.digital  --hostname gsd-publish-data
