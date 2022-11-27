# packer
- ec2 이미지 굽는 목적의 서버

# usage

### install packer
``` bash
brew tap hashicorp/tap
brew install hashicorp/tap/packer@v1.7.10
```

### build
``` bash
packer fmt ./builder/ecs.pkr.hcl
packer validate ./builder/ecs.pkr.hcl
packer build ./builder/ecs.pkr.hcl

```