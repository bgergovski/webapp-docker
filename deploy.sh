#!/bin/bash

cd terraform
# Function to execute Terraform commands
terraform_apply() {
    local var_flags=()

    # Add -var flags for provided variables
    [[ -n "${docker_tag}" ]] && var_flags+=("-var" "docker_tag=${docker_tag}")
    [[ -n "${hosted_zone_id}" ]] && var_flags+=("-var" "hosted_zone_id=${hosted_zone_id}")
    [[ -n "${domain_name}" ]] && var_flags+=("-var" "domain_name=${domain_name}")

    # Apply Terraform with var_flags array
    terraform apply -auto-approve "${var_flags[@]}"
}

# Ensure Terraform is initialized
echo "Initializing Terraform..."
terraform init -backend-config=config/backend.conf

# Prompt user for input
read -rp "Enter Docker Tag (default: v1.0.0): " docker_tag
read -rp "Enter Hosted Zone ID (default: Z3NDXD7R70IFO1): " hosted_zone_id
read -rp "Enter Domain Name (default: webapp-docker.gergovski.com): " domain_name

# Apply Terraform deployment
echo "Applying Terraform deployment..."
terraform_apply
