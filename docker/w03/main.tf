locals {
  resource_prefix = var.project_name
}

resource "docker_network" "application" {
  name = "${local.resource_prefix}-network"
}

resource "docker_volume" "postgres_data" {
  name = "${local.resource_prefix}-postgres-data"

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "docker_image" "postgres" {
  name         = "postgres:17-alpine"
  keep_locally = true
}

resource "docker_container" "database" {
  name  = "${local.resource_prefix}-database"
  image = docker_image.postgres.image_id

  labels {
    label = "managed-by"
    value = "terraform"
  }

  env = [
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}"
  ]

  networks_advanced {
    name    = docker_network.application.name
    aliases = ["database"]
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  healthcheck {
    test = [
      "CMD-SHELL",
      "pg_isready -U ${var.postgres_user} -d ${var.postgres_db}"
    ]

    interval     = "5s"
    timeout      = "3s"
    retries      = 10
    start_period = "10s"
  }
}

