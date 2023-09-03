output "ubuntu_ami_id" {
  description = "Latest Ubuntu AMI ID"
  value = data.aws_ami.ubuntu.id
}