provider "aws" {
  region = "ap-south-1"
}

#fetch the default vpc
data "aws_vpc" "default" {
  default = true
}

#fetch the default subnet
data "aws_subnets" "default" {

}

module "blue_instance" {
  source          = "./modules/ec2"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnets.default.ids[1]
  name            = "Blue Web Server"
  security_groups = [aws_security_group.ec2_sg.id]
}

module "green_instance" {
  source          = "./modules/ec2"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnets.default.ids[1]
  name            = "Green Web Server"
  security_groups = [aws_security_group.ec2_sg.id]
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnets.default.ids
  name            = "app-load-balancer"
  security_groups = [aws_security_group.lb_sg.id]
}

# Register Blue EC2 instance to Blue Target Group
resource "aws_lb_target_group_attachment" "blue_attachment" {
  target_group_arn = module.alb.blue_target_group_arn
  target_id        = module.blue_instance.id
  port             = 80

  depends_on = [module.blue_instance]
}

# Register Green EC2 instance to Green Target Group
resource "aws_lb_target_group_attachment" "green_attachment" {
  target_group_arn = module.alb.green_target_group_arn
  target_id        = module.green_instance.id
  port             = 80

  depends_on = [module.green_instance]
}