#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

docker run -v "${SCRIPT_DIR}"/..:/app -w /app \
  -e CF_APP_NAME -e NOTIFY_ENABLED \
  -e MOJSSO_ID -e MOJSSO_SECRET \
  -e CF_USER -e CF_PASSWORD \
  governmentpaas/cf-cli ci/deploy.sh
