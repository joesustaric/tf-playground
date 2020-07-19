#!/usr/bin/env bash

set -xo pipefail

echo "Running chekov....."
checkov -d .

echo "Checking if IAM Config is in sync....."
echo "todo assume role"

# The output of the assume role command will log out the AWS secrets.. 
# TODO - Find a better way to do this with Travis CI..
set +x
aws sts assume-role --role-arn "arn:aws:iam::580133377048:role/CI-Role" --output json --role-session-name Travis-CI
set -x

echo " Installing Iamy.."
echo "${PATH}"
curl https://github.com/99designs/iamy/releases/download/v2.3.2/iamy-darwin-amd64 --output iamy
