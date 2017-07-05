#!/bin/sh

set -eu

CF_API="https://api.cloud.service.gov.uk"
CF_ORG="moj-digital"
CF_SPACE="nomis-integration"

cf api "${CF_API}"
cf auth "${CF_USER}" "${CF_PASSWORD}"
cf target -o "${CF_ORG}" -s "${CF_SPACE}"
cf push --no-start "${CF_APP_NAME}"
cf set-env "${CF_APP_NAME}" MOJSSO_ID "${MOJSSO_ID}" > /dev/null
cf set-env "${CF_APP_NAME}" MOJSSO_SECRET "${MOJSSO_SECRET}" > /dev/null
cf start "${CF_APP_NAME}"
