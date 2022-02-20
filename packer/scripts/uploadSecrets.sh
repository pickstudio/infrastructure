#!/bin/bash

aws s3 cp ./provisionings/basic/files/secrets s3://pickstudio-secrets/secrets --recursive
