variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of IDs of public subnets to place the containers in."
  type        = list(string)
}

variable "tags" {
  description = "An optional map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}
