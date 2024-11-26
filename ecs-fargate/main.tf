provider "aws" {
  region = "us-west-2"
}

#Vpc
module "aws_vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

#private Subnet
module "aws_private_subnet" {
  source            = "./modules/subnets"
  availability_zone = var.availability_zone
  vpc_id            = module.aws_vpc.vpc_id
  depends_on        = [module.aws_vpc]
}

#Route Table
module "aws_route_table" {
  source = "./modules/routes"
  vpc_id = module.aws_vpc.vpc_id
}

#Attach subnet to routetable
resource "aws_route_table_association" "name" {
  subnet_id      = module.aws_private_subnet.id
  route_table_id = module.aws_route_table.id
}

#Private ECR VPC Docker Endpoint
resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id              = module.aws_vpc.vpc_id
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.aws_private_subnet.id]
  private_dns_enabled = true
  security_group_ids = [ module.aws_security_group.sg_id ]
  depends_on = [ module.aws_security_group ]
 
}

#Private ECR VPC api Endpoint
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id              = module.aws_vpc.vpc_id
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.aws_private_subnet.id]
  private_dns_enabled = true
  security_group_ids = [ module.aws_security_group.sg_id ]
  depends_on = [ module.aws_security_group ]
}

#Private ECR VPC api Endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = module.aws_vpc.vpc_id
  service_name      = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.aws_route_table.id]
}

module "aws_security_group" {
  source         = "./modules/security_group"
  cidr_block     = module.aws_private_subnet.cidr_block
  sg_name        = "fargate-sg"
  sg_description = "Fargate security group"
  vpc_id         = module.aws_vpc.vpc_id
  depends_on     = [module.aws_vpc, module.aws_private_subnet]
}

module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "aws_iam_task_execution_role" {
  source = "./modules/iam_role"
}

module "ecs_task_definition" {
  source             = "./modules/ecs_task_definition"
  repository_url     = var.repository_url
  image_tag          = var.image_tag
  containerPort      = var.containerPort
  hostPort           = var.hostPort
  execution_role_arn = module.aws_iam_task_execution_role.arn
  depends_on         = [module.aws_iam_task_execution_role]
}

module "ecs_service" {
  source          = "./modules/ecs_service"
  cluster_id      = module.ecs_cluster.id
  task_definition = module.ecs_task_definition.arn
  subnets         = module.aws_private_subnet.id
  security_group  = module.aws_security_group.sg_id
  depends_on      = [module.aws_private_subnet, module.ecs_task_definition]
}