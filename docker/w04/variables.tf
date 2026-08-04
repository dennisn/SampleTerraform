variable "web_ports" {
  description = "External ports for web containers"
  type        = list(number)
  default     = [8080, 8081, 8082]
}