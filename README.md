# pickstudio-infra

terraform code about pickstudio cloud infrastructure

# Requirements

- AWS access, secret key. Plz, refer to `.envrc.example`
- `tfenv` (using terraform 1.1.6) [Download Link](https://github.com/tfutils/tfenv)
- `packer` cli [Download Link](https://www.packer.io/downloads)
- `direnv` cli [Download Link](https://direnv.net/)
- `ansible` cli [Download Link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-macos)
    ``` bash
  pyenv
    pip uninstall ansible-base
    pip install ansible==5.3.0
    ```

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

# service host information
- buddystock_rest
    - development: https://development.pickstudio.io:40431
    - production: https://buddystock.kr:40431
- buddystock_youtube
    - development: https://development.pickstudio.io:40432
    - production: https://buddystock.kr:40432
- buddystock_data_processor
    - development: https://development.pickstudio.io:40433
    - production: https://buddystock.kr:40433


