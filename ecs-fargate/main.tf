provider "aws" {
  region = "us-west-2"
}

#Vpc
module "aws_vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.aws_vpc.vpc_id
  tags = {
    Name = "Internet Gateway"
  }
  depends_on = [module.aws_vpc]
}

#private Subnet
module "aws_subnet" {
  source            = "./modules/subnets"
  availability_zone = var.availability_zone
  vpc_id            = module.aws_vpc.vpc_id
}

#Route Table
module "aws_route_table" {
  source     = "./modules/routes"
  vpc_id     = module.aws_vpc.vpc_id
  gateway_id = aws_internet_gateway.igw.id
  depends_on = [module.aws_vpc, aws_internet_gateway.igw]
}

#Attach subnet to routetable
resource "aws_route_table_association" "private" {
  subnet_id      = module.aws_subnet.private_subnet_id
  route_table_id = module.aws_route_table.private-route-table-id
}

#Attach public subnet to routetable
resource "aws_route_table_association" "public" {
  subnet_id      = module.aws_subnet.public_subnet_id
  route_table_id = module.aws_route_table.public-route-table-id
}

#Private ECR VPC Docker Endpoint
resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id              = module.aws_vpc.vpc_id
  service_name        = "com.amazonaws.us-west-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.aws_subnet.private_subnet_id]
  private_dns_enabled = true
  security_group_ids  = [module.aws_sg_ecs_fargate.sg_id]
  depends_on          = [module.aws_sg_ecs_fargate]

}

#Private ECR VPC api Endpoint
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id              = module.aws_vpc.vpc_id
  service_name        = "com.amazonaws.us-west-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.aws_subnet.private_subnet_id]
  private_dns_enabled = true
  security_group_ids  = [module.aws_sg_ecs_fargate.sg_id]
  depends_on          = [module.aws_sg_ecs_fargate]
}

#Private ECR VPC api Endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = module.aws_vpc.vpc_id
  service_name      = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.aws_route_table.private-route-table-id]
}

module "aws_sg_ecs_fargate" {
  source         = "./modules/security_group"
  cidr_block     = module.aws_subnet.private_subnet_cidr_block
  sg_name        = "fargate-sg"
  sg_description = "Fargate security group"
  vpc_id         = module.aws_vpc.vpc_id
  depends_on     = [module.aws_vpc, module.aws_subnet]
}

module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "aws_iam_task_execution_role" {
  source = "./modules/iam_role"
}

module "aws_alb" {
  source = "./modules/alb"
  subnets = [module.aws_subnet.public_subnet_id,module.aws_subnet.public_subnet_1_id]
  security_groups = module.aws_sg_ecs_fargate.alb_sg_id
  vpc_id = module.aws_vpc.vpc_id
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
  subnets         = module.aws_subnet.private_subnet_id
  security_group  = module.aws_sg_ecs_fargate.sg_id
  depends_on      = [module.aws_subnet, module.ecs_task_definition,module.aws_alb,module.aws_iam_task_execution_role]
  alb_arn = module.aws_alb.alb_target_group_arn

}