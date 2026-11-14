# AWS Ubuntu EC2 + Nginx Provisioning with Terraform

This project provisions an AWS Free Tier **Ubuntu 26.04 LTS** EC2 instance in your default VPC using Terraform, configures an Nginx web server with a custom landing page via `user_data`, and sets up SSH access.

## Project Structure

```text
.
├── main.tf         # Core infrastructure resources (EC2, Security Group, Key Pair)
├── variables.tf    # Input variable definitions and default values
├── outputs.tf      # Output values (Public IP, Web URL, SSH command)
└── README.md       # Project documentation
```

## Prerequisites

1. **Terraform CLI** installed (`>= 1.5.0`)
2. **AWS CLI** configured with valid credentials (`aws configure`)
3. **Local SSH Key Pair** generated at `~/.ssh/terraform-aws-key`:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/terraform-aws-key -N ""
   ```

## Usage

### 1. Initialize Terraform
Download the required AWS provider plugins:
```bash
terraform init
```

### 2. Review Execution Plan
Preview the resources Terraform will create:
```bash
terraform plan
```

### 3. Deploy Infrastructure
Apply the configuration (optionally override default variables using `-var`):
```bash
terraform apply
```
*Example overriding the region:*
```bash
terraform apply -var="aws_region=us-east-1"
```

### 4. Verify Deployment
After `terraform apply` finishes:
- Open the **`nginx_url`** output in your browser (allow ~45 seconds for `user_data` to install Nginx).
- Run the **`ssh_command`** output in your terminal to log into the server.

### 5. Clean Up Resources
Destroy all provisioned resources (EC2 instance, Security Group, and Key Pair) without modifying your default VPC:
```bash
terraform destroy
```

## Inputs

| Name | Description | Default |
| :--- | :--- | :--- |
| `aws_region` | AWS region for deployment | `ap-south-1` |
| `instance_type` | EC2 instance type | `t2.micro` |
| `instance_name` | Name tag for the EC2 instance | `Terraform-Ubuntu26-Nginx` |
| `sg_name` | Name of the security group | `terraform-nginx-ubuntu26-sg` |
| `public_key_path` | Path to local SSH public key | `~/.ssh/terraform-aws-key.pub` |
| `html_content` | Custom HTML served by Nginx | `<h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>` |

## Outputs

| Name | Description |
| :--- | :--- |
| `instance_public_ip` | Public IPv4 address of the EC2 instance |
| `nginx_url` | Direct HTTP link to the Nginx web page |
| `ssh_command` | Ready-to-run SSH command to access the instance |

