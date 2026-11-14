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
  <img width="918" height="540" alt="Screenshot From 2026-11-14 11-39-24" src="https://github.com/user-attachments/assets/7fb384ce-9f02-4119-9d2c-a91009a395db" />

3. **AWS CLI** configured with valid credentials (`aws configure`)
<img width="1246" height="308" alt="image" src="https://github.com/user-attachments/assets/0b4c37c9-5bd1-4278-80ac-9a3a4d00708d" />

4. **Local SSH Key Pair** generated at `~/.ssh/terraform-aws-key`:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/terraform-aws-key -N ""
   ```
   <img width="1220" height="447" alt="Screenshot From 2026-11-14 12-05-21" src="https://github.com/user-attachments/assets/1d75994b-40e1-4d0a-977e-803f101220d7" />


## Usage

### 1. Initialize Terraform
Download the required AWS provider plugins:
```bash
terraform init
```
<img width="890" height="513" alt="Screenshot From 2026-11-14 11-41-46" src="https://github.com/user-attachments/assets/f64dcdd0-8a07-4655-83aa-91aff217d371" />


### 2. Review Execution Plan
Preview the resources Terraform will create:
```bash
terraform plan
```
<img width="2938" height="1664" alt="Screenshot From 2026-11-14 11-57-47" src="https://github.com/user-attachments/assets/2d78ab60-0238-4f6d-b351-b1c2f0721ebe" />


### 3. Deploy Infrastructure
Apply the configuration (optionally override default variables using `-var`):
```bash
terraform apply
```
<img width="2938" height="1664" alt="Screenshot From 2026-11-14 11-58-44" src="https://github.com/user-attachments/assets/dbac1f2b-8dd2-4311-8a0b-19bfe82c1ab0" />

*Example overriding the region:*
```bash
terraform apply -var="aws_region=ap-south-1"
```

### 4. Verify Deployment
After `terraform apply` finishes:
- Open the **`nginx_url`** output in your browser (allow ~45 seconds for `user_data` to install Nginx).
  <img width="1428" height="320" alt="Screenshot From 2026-11-14 12-15-50" src="https://github.com/user-attachments/assets/721b0b2d-a6a6-414c-a7b0-6db17838d5f2" />

- Run the **`ssh_command`** output in your terminal to log into the server.
<img width="1182" height="893" alt="Screenshot From 2026-11-14 12-10-45" src="https://github.com/user-attachments/assets/1a414b35-eadf-4af3-be76-051cdb665e79" />

### 5. Clean Up Resources
Destroy all provisioned resources (EC2 instance, Security Group, and Key Pair) without modifying your default VPC:
```bash
terraform destroy
```
<img width="912" height="487" alt="Screenshot From 2026-11-14 12-54-13" src="https://github.com/user-attachments/assets/e85dff8b-6904-4861-bd9f-8d70eb7129f4" />

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

