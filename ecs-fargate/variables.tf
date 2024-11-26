variable "cluster_name" {
  default = "terraform-fargate-cluster"
}

variable "hostPort" {
  default = 8080
}

variable "containerPort" {
  default = 8080
}

variable "repository_url" {
  default = "992382558669.dkr.ecr.us-west-2.amazonaws.com/spring-app"
}

variable "image_tag" {
  default = "v1"
}

variable "availability_zone" {
  default = "us-west-2a"
}