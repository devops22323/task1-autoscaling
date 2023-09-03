# Launch Configuration for ASG
resource "aws_launch_configuration" "web-instance-lc" {
  name_prefix   = "web-instance-lc"
  image_id      =  data.aws_ami.ubuntu.id # Ubuntu AMI from ap-southeast-4
  instance_type = "t3.micro"
  key_name = var.instance_keypair
  security_groups = [aws_security_group.web-sg.id]
  user_data     = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "Hello World" > /var/www/html/index.html
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web-asg" {
  name                 = "web-asg"
  # Attach ASG to public subnets for external access
  # availability_zones = [ "ap-southeast-4a" ]
  launch_configuration = aws_launch_configuration.web-instance-lc.name
  min_size             = 1
  max_size             = 10
  desired_capacity     = 1
  #vpc_zone_identifier = aws_subnet.public_subnets[*].id
  vpc_zone_identifier = [
    aws_subnet.public_subnets[0].id, # ap-southeast-2a
    aws_subnet.public_subnets[1].id, # ap-southeast-2b
    aws_subnet.public_subnets[2].id, # ap-southeast-2c
  ]

  
  tag {
    key                 = "Name"
    value               = "Asg-web-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
