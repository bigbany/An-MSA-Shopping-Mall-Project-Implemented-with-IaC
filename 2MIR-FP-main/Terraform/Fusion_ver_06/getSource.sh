#!/bin/bash

### <초기화>
#sed -i "/TF_STATE_S3/c\     TF_STATE_S3  = \"default\"" ./terragrunt.hcl
#sed -i "/TF_DYNAMO_DB/c\     TF_DYNAMO_DB = \"default\"" ./terragrunt.hcl
sed -i '/bucket  = /c\    bucket  = "example_TF_S3"' ./terragrunt.hcl
sed -i '/bucket  = /c\        bucket  = "example_TF_S3"' ./DEV/DEV_EKS/terragrunt.hcl
sed -i '/dynamodb_table = /c\    dynamodb_table = "example_TF_DY"' ./terragrunt.hcl
### </초기화>

### <tfstate용 S3, dynamoDB 이름 받기>
echo "Insert TF_STATE_S3 name"
read TF_STATE_S3
sed -i "s/example_TF_S3/$TF_STATE_S3/g" ./terragrunt.hcl
sed -i "s/example_TF_S3/$TF_STATE_S3/g" ./DEV/DEV_EKS/terragrunt.hcl

echo "Insert TF_DYNAMO_DB name"
read TF_DYNAMO_DB
sed -i "s/example_TF_DY/$TF_DYNAMO_DB/g" ./terragrunt.hcl

echo "your tfstate terragrunt_state storage in ./terragunt.hcl"
echo "TF_STATE_S3 = $TF_STATE_S3";
echo "TF_DYNAMO_DB = $TF_DYNAMO_DB";
echo "plz sh first.sh"
### </tfstate용 S3, dynamoDB 이름 받기>
