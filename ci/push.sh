#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

docker run -v "${SCRIPT_DIR}"/..:/app -w /app \
  -e CF_APP_NAME \
  -e CF_USER -e CF_PASSWORD \
  -e NOTIFY_ENABLED -e GOVUK_NOTIFY_API_KEY \
  -e MOJSSO_ID -e MOJSSO_SECRET -e MOJSSO_URL \
  -e API_AUTH \
  governmentpaas/cf-cli ci/deploy.sh
