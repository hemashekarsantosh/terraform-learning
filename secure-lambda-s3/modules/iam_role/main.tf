# Lambda Permission
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_s3_role" {

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = var.role_name
  tags = {
    Name = var.role_name
  }
}



#Iam Policy for s3 and cloud watch logs
resource "aws_iam_policy" "lambda_s3_cloudwatch" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.s3_cloudwatch_policy.json

}

#S3 and Cloudwatch policy
data "aws_iam_policy_document" "s3_cloudwatch_policy" {
  statement {
    actions   = ["s3:*"]
    resources = ["*"]
  }
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

}

#Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_s3_role.name
  policy_arn = aws_iam_policy.lambda_s3_cloudwatch.arn
}

#Attach VPC Policy to Lambda
resource "aws_iam_role_policy_attachment" "attach_vpc_policy" {
  role       = aws_iam_role.lambda_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
