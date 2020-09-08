#!/bin/bash

aws s3 sync ./provisionings/basic/files/secrets s3://pickstudio-secrets/secrets

aws s3 cp s3://pickstudio-secrets/secrets/pickstudio_id_rsa ~/.ssh/id_rsa
aws s3 cp s3://pickstudio-secrets/secrets/pickstudio_id_rsa.pub ~/.ssh/id_rsa.pub
