#!/bin/bash
ENV_UPPERCASE=$(echo $ENVIRONMENT | tr '[:lower:]' '[:upper:]')
# variable_name_for_gcp_credentials=${ENV_UPPERCASE}_GCP_CREDENTIALS
# variable_name_for_state_bucket_name=${ENV_UPPERCASE}_STATEFILE_BUCKET_NAME
# variable_name_for_rancher_api_url=${ENV_UPPERCASE}_RANCHER_API_URL
# variable_name_for_rancher_access_key=${ENV_UPPERCASE}_RANCHER_ACCESS_KEY
# variable_name_for_rancher_secret_key=${ENV_UPPERCASE}_RANCHER_SECRET_KEY
# variable_name_for_k8s_cluster_name=${ENV_UPPERCASE}_K8S_CLUSTER_NAME

# echo $GCP_STATE_BUCKET_KEY > /tmp/state_auth.json

echo ${STATE_GCP_CREDENTIALS} > /tmp/gcloud_auth.json
export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcloud_auth.json
export GOOGLE_PROJECT=$(cat /tmp/gcloud_auth.json | jq -r '.project_id')
export TF_VAR_environment=$( cut -d '_' -f 1 <<< "$ENVIRONMENT" )
# export "CLUSTERNAME=${!variable_name_for_k8s_cluster_name}"
# export "RANCHER_URL=${!variable_name_for_rancher_api_url}"
# export "RANCHER_ACCESS_KEY=${!variable_name_for_rancher_access_key}"
# export "RANCHER_SECRET_KEY=${!variable_name_for_rancher_secret_key}"
# export "RANCHER_INSECURE=true"
# export "RANCHER_TOKEN=$RANCHER_ACCESS_KEY:$RANCHER_SECRET_KEY"

# if [ ! -z "$CLUSTERNAME" ] && [ ! -z "$RANCHER_URL" ] && [ ! -z "$RANCHER_ACCESS_KEY" ] && [ ! -z "$RANCHER_SECRET_KEY" ]; then
#     CLUSTER_ID=$(curl -s -u $RANCHER_TOKEN $RANCHER_URL/clusters?name=$CLUSTERNAME --insecure | jq -r .data[].id)
#     curl -s -u $RANCHER_TOKEN $RANCHER_URL/clusters/$CLUSTER_ID?action=generateKubeconfig -X POST -H 'content-type:application/json' --insecure | jq -r .config > /tmp/kubeconfig.yml
#     export KUBECONFIG=/tmp/kubeconfig.yml
# fi


# for var in $(echo "${EXTRA_VARS}" | jq -r '.[]'); do
#     KEY=$( cut -d ':' -f 1 <<< "$var" )
#     variable_name_for_extra_var="${ENV_UPPERCASE}_${KEY}"
#     terraform_variable_name_for_extra_var=$( cut -d ':' -f 2- <<< "$var" )
#     export "${terraform_variable_name_for_extra_var}=${!variable_name_for_extra_var}"
# done

# echo -e 'terraform {\n\tbackend "gcs" {}\n}' > backend.tf

terraform init -reconfigure
