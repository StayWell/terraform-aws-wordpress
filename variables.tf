variable "name" {
  description = "(optional) Must be unique in order to deploy multiple sites under the same env"
  default     = "wp"
}

variable "env" {
  description = "(optional) Unique identifier used to name all resources"
  default     = "default"
}

variable "tags" {
  description = "(optional) Additional tags applied to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#vpc_id"
  default     = ""
}

variable "listener_arn" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html#listener_arn"
  default     = ""
}

variable "lb_dns_name" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/route53_record.html#name-1"
  default     = ""
}

variable "lb_zone_id" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/route53_record.html#zone_id-1"
  default     = ""
}

variable "domain" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/route53_record.html#name"
  default     = ""
}

variable "route53_zone_id" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/route53_record.html#zone_id"
  default     = ""
}

variable "cluster_id" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/ecs_service.html#cluster"
  default     = ""
}

variable "image" {
  description = "(optional) https://hub.docker.com/_/wordpress/?tab=tags"
  default     = "wordpress:latest"
}

variable "desired_count" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/ecs_service.html#desired_count"
  default     = "1"
}

variable "cpu" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#cpu"
  default     = "256"
}

variable "memory" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#memory"
  default     = "256"
}

variable "db_host" {
  description = "(required) https://hub.docker.com/_/wordpress/ - search WORDPRESS_DB_HOST"
  default     = ""
}

variable "db_user" {
  description = "(required) https://hub.docker.com/_/wordpress/ - search WORDPRESS_DB_USER"
  default     = ""
}

variable "db_password" {
  description = "(required) https://hub.docker.com/_/wordpress/ - search WORDPRESS_DB_PASSWORD"
  default     = ""
}

variable "region" {
  description = "(required) AWS region"
  default     = ""
}

variable "container_port" {
  description = "(optional) Service port inside running container"
  default     = "80"
}
