#!/usr/bin/env bash

set -xo pipefail

echo "Running chekov....."
checkov -d .

echo "Checking if IAM Config is in sync....."

## Fix this not working...
echo " Installing Iamy.."
curl -L https://github.com/99designs/iamy/releases/download/v2.3.2/iamy-linux-amd64 --output iamy_ci
chmod +x iamy_ci
AWS_REGION=ap-southeast-2 ./iamy_ci pull -d ./global/IAM

# Check for any new or modified git files.
if [[ $(git add -A -n | wc -l) -ge 0 ]]; then
    echo "IAM changes.. Needs attention"
    exit 1
fi

