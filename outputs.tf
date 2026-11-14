output "instance_public_ip" {
  description = "Public IP address of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

output "nginx_url" {
  description = "URL to access the Nginx web server"
  value       = "http://${aws_instance.nginx_server.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = "ssh -i ${trimsuffix(var.public_key_path, ".pub")} ubuntu@${aws_instance.nginx_server.public_ip}"
}

