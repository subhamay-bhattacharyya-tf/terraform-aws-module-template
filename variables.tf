variable "name" {
  description = "Name for the primary resource created by this module."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all taggable resources."
  type        = map(string)
  default     = {}
}

