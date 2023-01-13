#!/bin/bash

set -e

if [[ "${1}x" == "x" ]]; then
    echo "The instance name was not provided"
    echo "Usage: ${0} bastion-host-username"
    echo " e.g.: ${0} bastion-host-hendrix"
    exit 1
fi
name=${1}


export TF_VAR_name="${name}"

export TF_VAR_ssh_key="../ssh_key"

if [[ "${DESTROY_TF}" == "true" ]]; then
    terraform -chdir=infrastructure destroy -auto-approve
    rm ssh_key ssh_key.pub infrastructure/terraform.tfstate.backup infrastructure/terraform.tfstate infrastructure/.terraform.lock.hcl
    exit 0
fi

ssh-keygen -f ssh_key -N ""

terraform -chdir=infrastructure init
terraform -chdir=infrastructure apply -auto-approve
