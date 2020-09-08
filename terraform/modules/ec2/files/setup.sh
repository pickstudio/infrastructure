#!/bin/bash
set -e

app () {
  su ec2-user
  local authorizedKeyFile='/home/ec2-user/.ssh/authorized_keys'
  IFS=$"\,"
  local accounts=($github_accounts)
  IFS=$' '

  for account in "${accounts[@]}"; do
    echo $account
    curl -s https://github.com/$account.keys >> $authorizedKeyFile
  done

  chown -R ec2-user:ec2-user $authorizedKeyFile
  chmod 600 $authorizedKeyFile
}

app
