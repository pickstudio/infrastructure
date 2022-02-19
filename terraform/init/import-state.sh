#!/bin/bash


terraform import aws_s3_bucket.bucket pickstudio-infrastructure
terraform import aws_dynamodb_table.terraform-lock pickstudio-terraform-lock




