# bastion-host

This repository contains terraform recipes to bootstrap a single EC2 instance on AWS.

## Requirements

- [terraform](https://developer.hashicorp.com/terraform/downloads)

## How to

Make sure you have aws credentials configured on you local machine.

Launch the bastion host infrastructure:

```sh
./run.sh bastion-host-username
```

## Clean-up

```sh
DESTROY_TF=true ./run.sh bastion-host-username
```
