#!/usr/bin/env bash

set -xo pipefail

echo "Checking if IAM Config is in sync....."

echo " Installing Iamy.."
curl -L https://github.com/99designs/iamy/releases/download/v2.3.2/iamy-linux-amd64 --output iamy_ci
chmod +x iamy_ci
AWS_REGION=ap-southeast-2 ./iamy_ci pull -d ./global/IAM
rm iamy_ci

# if there are changes fail the check
if [[ $(git add -A -n | wc -l) -ne 0 ]]; then
    echo "IAM changes detected.. Needs attention."
    exit 1
fi

echo "IAM Configuration is up to date."
