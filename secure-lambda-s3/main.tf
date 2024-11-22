provider "aws" {
  region = "us-west-2"
}

module "aws_vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "aws_private_subnet" {
  source = "./modules/subnets"
  availability_zone = var.az
  vpc_id = module.aws_vpc.vpc_id
  depends_on = [ module.aws_vpc ]
}

module "aws_private_route" {
  source = "./modules/routes"
  vpc_id = module.aws_vpc.vpc_id
  depends_on = [ module.aws_vpc ]
}

resource "aws_route_table_association" "private_subnet_route" {
  subnet_id = module.aws_private_subnet.id
  route_table_id = module.aws_private_route.id
  depends_on = [ module.aws_private_route,module.aws_private_subnet ]
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = module.aws_vpc.vpc_id
  service_name = "com.amazonaws.us-west-2.s3"
}

module "s3-bucket" {
  source = "./modules/s3"
  bucket_name = "excel-poc-v1-2"
}

