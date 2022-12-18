module github.com/pickstudio/infrastructure/dockerfiles/prometheus-ecs-discovery

go 1.19

require (
	github.com/aws/aws-sdk-go-v2/config v1.18.5
	github.com/aws/aws-sdk-go-v2/credentials v1.13.5
	github.com/aws/aws-sdk-go-v2/service/ec2 v1.76.1
	github.com/aws/aws-sdk-go-v2/service/ecs v1.21.0
	github.com/aws/aws-sdk-go-v2/service/sts v1.17.7
	github.com/aws/smithy-go v1.13.5
	github.com/go-yaml/yaml v2.1.0+incompatible
)

require (
	github.com/aws/aws-sdk-go-v2 v1.17.3 // indirect
	github.com/aws/aws-sdk-go-v2/feature/ec2/imds v1.12.21 // indirect
	github.com/aws/aws-sdk-go-v2/internal/configsources v1.1.27 // indirect
	github.com/aws/aws-sdk-go-v2/internal/endpoints/v2 v2.4.21 // indirect
	github.com/aws/aws-sdk-go-v2/internal/ini v1.3.28 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/presigned-url v1.9.21 // indirect
	github.com/aws/aws-sdk-go-v2/service/sso v1.11.27 // indirect
	github.com/aws/aws-sdk-go-v2/service/ssooidc v1.13.10 // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
)
