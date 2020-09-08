#!/bin/bash

aws s3 sync s3://pickstudio-secrets/secrets ./packer/provisionings/basic/files/secrets
