# packer
- ec2 이미지 굽는 목적의 서버

# image ECS

``` bash
# get latest image
aws ssm get-parameters \
  --region ap-northeast-2 \
  --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended \
  | jq ".Parameters[0].Value | fromjson | .image_id"
```
