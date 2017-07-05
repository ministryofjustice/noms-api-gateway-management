#!/bin/sh

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

docker run -v "${SCRIPT_DIR}"/..:/app -w /app \
  -e MOJSSO_USER="${MOJSSO_USER}" -e MOJSSO_PASSWORD="${MOJSSO_PASSWORD}" \
  -e DOMAIN_UNDER_TEST="${DOMAIN_UNDER_TEST}" -e AUTH_ENABLED="${AUTH_ENABLED:-true}" \
  "${DOCKER_REGISTRY}"/nomis-api-access cucumber
