#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

docker build -t dumpster-archiver "$DIR/image/" >> "$DIR/run.log" 2>&1
docker run --rm --env-file "$DIR/.env" dumpster-archiver >> "$DIR/run.log" 2>&1
