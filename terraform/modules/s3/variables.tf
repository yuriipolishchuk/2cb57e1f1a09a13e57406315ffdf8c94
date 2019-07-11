variable "bucket" {
  default = ""
}

variable "versioning_enabled" {
  default = true
}

variable "tags" {
  type    = "map"
  default = {}
}

