#!/bin/bash

set -e -u

if [[ "${staging_cf_skip_cert_check:-false}" == "false" ]]; then
  cf api $staging_cf_api
else
  cf api $staging_cf_api --skip-ssl-validation
fi
cf auth "$staging_cf_username" "$staging_cf_password"
cf target -o $staging_cf_organization -s $staging_cf_space

echo Fetching current env vars
space_guid=$(cat ~/.cf/config.json | jq -r .SpaceFields.GUID)
app=$(cf curl /v2/spaces/${space_guid}/apps\?q=name:${staging_cf_appname} | jq -r ".resources[0]")
staging_env_vars=$(echo $app | jq -r '.entity.environment_json | keys | . | join(",")')

if [[ "$staging_env_vars" != "$prod_env_vars" ]]; then
  echo "Staging dingo-api has different env vars to production!"
  echo "Staging: ${staging_env_vars}"
  echo "Prod:    ${prod_env_vars}"
  exit 1
fi
