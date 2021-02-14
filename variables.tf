variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of IDs of public subnets to place the containers in."
  type        = list(string)
}

variable "task_container_override" {
  description = "Container override for the Fargate task started by the Step Functions state machine."
  default     = {}
}

variable "task_container_image" {
  description = "The container image to use for the Fargate task."
  default     = "vydev/awscli"
}

variable "tags" {
  description = "An optional map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}
