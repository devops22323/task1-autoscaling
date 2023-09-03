###  Output Values

output "public_ip_of_bastion_host" {
    description = "this is the public IP"
    value = aws_instance.bastion_host.public_ip
}

output "private_ip_of_bastion_host" {
    description = "this is the public IP"
    value = aws_instance.bastion_host.private_ip
}