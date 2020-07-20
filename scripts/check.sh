#!/usr/bin/env bash

set -xo pipefail

echo "Running chekov....."
checkov -d .

echo "Checking if IAM Config is in sync....."
echo "todo assume role"

# The output of the assume role command will log out the AWS secrets.. 
# TODO - Find a better way to do this with Travis CI..
aws sts assume-role --role-arn "arn:aws:iam::580133377048:role/CI-Role" --output json --role-session-name ci-session > /dev/null 2>&1


## Fix this not working...
echo " Installing Iamy.."
curl -L https://github.com/99designs/iamy/releases/download/v2.3.2/iamy-linux-amd64 --output iamy_ci
chmod +x iamy_ci
./iamy_ci pull -d ./global/IAM

git ls-files -m
