variable "web_ports" {
  description = "External ports for web containers"
  type        = list(number)
  default     = [8080, 8081, 8082]
}

variable "web_containers" {
  description = "Web container configuration"
  type = map(object({
    test_label    = string
    external_port = number
  }))

  default = {
    frontend = {
      test_label    = "front_end"
      external_port = 8080
    }

    admin = {
      test_label    = "admin"
      external_port = 8081
    }

    report = {
      test_label    = "reporting"
      external_port = 8082
    }
  }
}