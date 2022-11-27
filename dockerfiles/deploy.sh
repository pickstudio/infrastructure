#!/usr/bin/env bash

name=""
region="ap-northeast-2"
tag=""
version=""

usage() {
  echo "
Description: Docker Push
Usage: $(basename $0)
  -n  directory name that Dockerfile exists (grafana)
  -t  tag (tag directory e.g. 9.2.6)
  -v  version (v0.1)
  [-h help]
"
exit 1;
}

while getopts 'n:t:v:h' optname; do
  case "${optname}" in
    h) usage;;
    n) name=${OPTARG};;
    t) tag=${OPTARG};;
    v) version=${OPTARG};;
    *) usage;;
  esac

done

# prepare variables
[ -z "${name}" ] && >&2 echo "Error: -n directory name required" && usage
[ -z "${region}" ] && >&2 echo "Error: -r region required" && usage
[ -z "${tag}" ] && >&2 echo "Error: -t tag required" && usage
[ -z "${version}" ] && >&2 echo "Error: -v tag required" && usage

image_name="infrastructure/${name}"
account=$(aws sts get-caller-identity --query Account --output text)
ecr_url="${account}.dkr.ecr.${region}.amazonaws.com"
ecr_image_name="${ecr_url}/${image_name}"

echo image_name: ${image_name}
echo tag: ${tag}
echo region: ${region}
echo version: ${version}
echo account: ${account}

# setup ECR to push docker image into the ECR
aws ecr get-login-password --region "${region}" | docker login --username AWS --password-stdin "${ecr_url}"
aws ecr create-repository --repository-name ${image_name} --image-tag-mutability IMMUTABLE

# docker build
docker buildx create --use
docker buildx create --name multiarch-builder --use
docker buildx build --platform linux/amd64,linux/arm64/v8,linux/arm/v7 -t "${ecr_image_name}:${tag}-${version}" -t ${ecr_image_name}:latest --push "${name}/${tag}"
docker buildx stop multiarch-builder
docker buildx rm multiarch-builder