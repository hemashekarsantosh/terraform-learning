resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type =  var.instance_type
  subnet_id = var.subnet_id
  security_groups = var.security_groups

  tags = {
    Name = var.name
  }

  user_data = <<-EOF
          #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><head><title>Instance Name</title></head><body><h1>Welcome to ${var.name}</h1></body></html>" > /var/www/html/index.html

  EOF

  lifecycle {
    create_before_destroy = true
  }
}