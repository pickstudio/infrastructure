#!/bin/bash

aws s3 sync s3://pickstudio-secrets/secrets ./provisionings/basic/files/secrets

cp ./provisionings/basic/files/secrets/pickstudio_id_rsa ../pickstudio.pem