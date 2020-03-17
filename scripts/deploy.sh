#!/bin/bash

AWS_ACCOUNT_ID=$1
ENV=$2

aws ecr get-login --region "us-east-1" --no-include-email | bash
temp_role=$(aws sts assume-role --role-arn "arn:aws:iam::$AWS_ACCOUNT_ID:role/CIService" --role-session-name "cli-session")
export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)

serverless deploy --verbose --stage "${ENV}"
