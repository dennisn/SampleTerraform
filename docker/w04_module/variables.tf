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

variable "application_services" {
  description = "Application service container configuration"

  type = map(object({
    image         = string
    internal_port = optional(number)
    external_port = optional(number)
    labels        = optional(map(string), {})
  }))

  default = {
    cache = {
      image = "redis:alpine"
      labels = {
        service = "cache"
        method  = "module"
      }
    }

    static = {
      image         = "httpd:alpine"
      internal_port = 80
      external_port = 8090
      labels = {
        service = "static"
        method  = "module"
      }
    }
  }
}