terraform {
  required_version = ">= 1.8.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0"
    }
  }

  backend "local" {}
  
#   backend "local" {
#     path = "terraform.tfstate"
#   }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

module "application" {
  source = "../../modules/app"

  environment = "dev"
  ext_port    = 8086
}