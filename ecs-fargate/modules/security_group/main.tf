resource "aws_security_group" "sg_fargate" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  depends_on = [ aws_security_group.sg_alb ]
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress" {
  cidr_ipv4 = var.cidr_block
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  security_group_id = aws_security_group.sg_fargate.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_ecs" {
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.sg_alb.id
  security_group_id = aws_security_group.sg_fargate.id
}

resource "aws_vpc_security_group_egress_rule" "sg_egress" {
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  security_group_id = aws_security_group.sg_fargate.id
}

resource "aws_security_group" "sg_alb" {
  name= "alb-sg"
  description = "slb sg"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  ip_protocol = "-1"
  
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.sg_alb.id
  
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.sg_alb.id
}
