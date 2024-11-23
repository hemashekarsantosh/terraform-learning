provider "aws" {
  region = "us-west-2"
}

#VPC
module "aws_vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

#Private Subnet
module "aws_private_subnet" {
  source            = "./modules/subnets"
  availability_zone = var.az
  vpc_id            = module.aws_vpc.vpc_id
  depends_on        = [module.aws_vpc]
}

#Route Table 
module "aws_private_route" {
  source     = "./modules/routes"
  vpc_id     = module.aws_vpc.vpc_id
  depends_on = [module.aws_vpc]
}

#Attach Route Table to Private Subnet
resource "aws_route_table_association" "private_subnet_route" {
  subnet_id      = module.aws_private_subnet.id
  route_table_id = module.aws_private_route.id
  depends_on     = [module.aws_private_route, module.aws_private_subnet]
}

#s3 endpoint for VPC
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = module.aws_vpc.vpc_id
  service_name = "com.amazonaws.us-west-2.s3"
}

#s3 bucket
module "s3-bucket" {
  source      = "./modules/s3"
  bucket_name = "excel-poc-v1-2"
}

#iam_role for Lambda with s3 access and cloud watch logs
module "iam_role" {
  source      = "./modules/iam_role"
  depends_on  = [module.aws_vpc, module.aws_private_subnet]
  role_name   = "TerraformLambdaS3Role"
  policy_name = "TerraformLambdaS3Policy"
}

module "lambda_security_group" {
  source         = "./modules/security_group"
  vpc_id         = module.aws_vpc.vpc_id
  sg_name        = "lambda_security_group"
  sg_description = "Security group for lambda"
  cidr_block     = module.aws_vpc.cidr_block
  depends_on     = [module.aws_vpc]
}


#archive file
data "archive_file" "zip_python_code" {
  type        = "zip"
  source_dir  = "./python"
  output_path = "pythonv1.zip"
}

resource "aws_lambda_function" "lambda_fun" {
  filename      = "pythonv1.zip"
  function_name = "lambda_s3_to_excel"
  role          = module.iam_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  vpc_config {
    security_group_ids = [module.lambda_security_group.sg_id]
    subnet_ids         = [module.aws_private_subnet.id]
  }
  memory_size = 1024
  depends_on = [module.iam_role, data.archive_file.zip_python_code, module.lambda_security_group, module.aws_private_subnet]

}

# S3 permission to trigger lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_fun.arn
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3-bucket.arn
}

#S3 Bucket Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3-bucket.name
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_fun.arn
    events              = ["s3:ObjectCreated:*"]
   # filter_prefix       = "input/"
    filter_suffix       = ".xlsx"
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}