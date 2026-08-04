resource "docker_container" "this" {
  name = var.name
  image = var.image_id

  networks_advanced {
    name = var.network_name
  }

  dynamic "ports" {
    for_each = (
        var.internal_port != null &&
        var.external_port != null
    ) ? [1] : []

    content {
        internal = var.internal_port
        external = var.external_port
    }
  }

  dynamic "labels" {
    for_each = var.labels

    content {
      label = labels.key
      value = labels.value
    }
    
  }
}