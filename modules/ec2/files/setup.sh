#!/bin/bash
set -e

su ec2-user

GITHUB_ACCOUNTS=${github_accounts}

app () {
  local authorizedKeyFile='/home/ec2-user/.ssh/authorized_keys'
  IFS=$'\,'
  local accounts=($GITHUB_ACCOUNTS)
  IFS=$' '

  for account in "${accounts[@]}"; do
    echo $account
    curl -s https://github.com/$account.keys >> $authorizedKeyFile
  done

  chown -R ec2-user:ec2-user $authorizedKeyFile
  chmod 600 $authorizedKeyFile
}

aws s3 cp s3://pickstudio-secrets/secrets/pickstudio_id_rsa ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
aws s3 cp s3://pickstudio-secrets/secrets/pickstudio_id_rsa.pub ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa.pub
cat /home/ec2-user/.ssh/id_rsa.pub >> /home/ec2-user/.ssh/authorized_keys

app
