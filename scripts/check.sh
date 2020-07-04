#!/usr/bin/env bash

set -xo pipefail

echo "Running chekov....."
checkov -d .
