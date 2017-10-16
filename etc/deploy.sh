#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Missing PAAS space argument"
    echo "  deploy.sh staging|production"
    exit 1
fi

PAAS_SPACE=$1
cf login -u $PAAS_USER -p $PAAS_PASSWORD -a https://api.cloud.service.gov.uk -o government-service-data -s $PAAS_SPACE
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin blue-green-deploy -f -r CF-Community

cf bind-service $PAAS_SERVICE cgsd-pg-service
cf set-env $PAAS_SERVICE SECRET_KEY_BASE $APP_SECRET_KEY_BASE
cf set-env $PAAS_SERVICE HTTP_BASIC_AUTH_PASSWORD $HTTP_BASIC_AUTH_PASSWORD
cf set-env $PAAS_SERVICE HTTP_BASIC_AUTH_USERNAME $HTTP_BASIC_AUTH_USERNAME
cf blue-green-deploy $PAAS_SERVICE
