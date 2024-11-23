resource "aws_security_group" "sg_lambda" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "sg_lambda_egress" {
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
  security_group_id = aws_security_group.sg_lambda.id
}

resource "aws_vpc_security_group_ingress_rule" "sg_lambda_ingress" {
  cidr_ipv4 = var.cidr_block
  from_port = 0
  to_port = 65535
  ip_protocol = "tcp"
  security_group_id = aws_security_group.sg_lambda.id
}