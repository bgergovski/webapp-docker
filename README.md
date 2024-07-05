# webapp-docker

This project contains Terraform files in the `terraform` folder, application source code in the `src` folder, and Dockerfile along with deployment scripts in the root folder. This is the [presentation](presentation.docx) for the Analysis and Planning Task.

## How to Run

### Prerequisites

- **Terraform**: Ensure Terraform is installed on your machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html) and follow the installation instructions for your operating system.
- **Docker**: Ensure Docker is installed on your machine. You can download it from [Docker's official website](https://www.docker.com/products/docker-desktop) and follow the installation instructions for your operating system.
- **AWS Credentials**: Make sure your AWS credentials are configured either through environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`) or AWS CLI configuration (`aws configure`).
- **Route53 Zone**: Ensure you have a Route53 zone created and registered to use a custom domain.
-  **Terraform State Management**: 
   - Create an S3 bucket to store Terraform state files. Replace `bucket-terraform-demo` with your desired bucket name.
   - Create a DynamoDB table named `terraform-state-lock` to handle state locking for safe concurrent Terraform operations.

   Example Terraform configuration for state storage:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "bucket-terraform-demo"
       key            = "terraform.tfstate"
       region         = "your-aws-region"
       dynamodb_table = "terraform-state-lock"
     }
   }

## Deployment Details

### Default Variables

The deployment script (`deploy.sh`) uses the following variables, which have default values defined in `variables.tf`:

- **docker_tag**: This variable specifies the Docker image tag used for deployment. By default, it is set to `"v1.0.0"`.
  
- **hosted_zone_id**: This variable represents the Route53 hosted zone ID where DNS records will be managed. The default value is `"Z3NDXD7R70IFO1"`.

- **domain_name**: This variable defines the domain name associated with the application. The default value is `"webapp-docker.gergovski.com"`.


### Steps to Deploy

1. **Clone the Repository**: Clone this repository to your local machine.

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ./deploy.sh