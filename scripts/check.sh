#!/usr/bin/env bash

set -xo pipefail

echo "Running chekov....."
checkov -d .

echo "Checking if IAM Config is in sync....."
echo "todo assume role"

# The output of the assume role command will log out the AWS secrets.. 
# TODO - Find a better way to do this with Travis CI..
aws sts assume-role --role-arn "arn:aws:iam::580133377048:role/CI-Role" --output json --role-session-name Travis-CI > /dev/null 2>&1

echo " Installing Iamy.."
curl https://github.com/99designs/iamy/releases/download/v2.3.2/iamy-darwin-amd64 --output iamy

iamy pull -d ./global/IAM

git diff-index --quiet HEAD --
