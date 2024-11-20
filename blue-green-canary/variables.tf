variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0aebec83a182ea7ea" # ap-south-1  amazon Linux
}