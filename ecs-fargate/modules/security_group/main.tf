resource "aws_security_group" "sg_fargate" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress" {
  cidr_ipv4 = var.cidr_block
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  security_group_id = aws_security_group.sg_fargate.id
}

resource "aws_vpc_security_group_egress_rule" "sg_egress" {
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  security_group_id = aws_security_group.sg_fargate.id
}

