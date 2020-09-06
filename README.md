# pickstudio-infra

terraform code about pickstudio cloud infrastructure

# Requirements

- `tfenv` (using terraform 0.13.2)
- AWS access, secret key. Plz, refer to `.envrc.example`
- `direnv` cli

# getting start

``` bash
$ cd ${PROJECT_PATH}
$ cp .envrc.example .envrc
$ vi .envrc # modify .envrc
$ direnv allow
$ terraform init
$ terraform plan
# check the descriptions of terraform plan
$ terraform apply
# Do yes or No
```