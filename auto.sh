#!/bin/bash
if [[ "upload-data" == "$1" ]]; then
    aws s3api put-object --bucket default-task3-raw --key $2 --body data/$2
elif [[ "apply" == "$1" ]]; then
    terraform apply -var-file="dev.tfvars"
elif [[ "upload-pyspark" == "$1" ]]; then
    aws s3api put-object --bucket default-task3-glue-job-scripts --key $2 --body $2
elif [[ "destroy" == "$1" ]]; then
    terraform destroy -var-file="dev.tfvars"
else
    echo "plz type in argument"
fi