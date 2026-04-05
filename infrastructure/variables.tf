variable "flatcar_channel" {
  type        = string
  description = "Flatcar Container Linux channel"
  default     = "stable"
}

variable "flatcar_version" {
  type        = string
  description = "Flatcar Container Linux version"
  default     = "current"
}
