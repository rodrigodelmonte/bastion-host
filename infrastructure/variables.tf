variable "name" {
  type        = string
  description = "Name used identified resources"
}

variable "ssh_key" {
  description = "The path to the SSH key to use for the public instance. A file in the same path and the same name but `.pub` is expected."
}

variable "aws_availability_zones" {
  type        = list(any)
  description = "Availability zones to be used"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "tags" {
  description = "Map of tags to add to all resources"
  type        = map(any)
  default     = { "owner" : "advanced-tests", "expiration" : "24h" }
}
