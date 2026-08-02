moved {
  from = docker_container.database
  to   = docker_container.postgres
}

import {
  to = docker_network.external
  id = "7c9d79f3934c284dd4e77cd6e1d5996ae8eb988a387509abaff7e8ec222c235c"
}