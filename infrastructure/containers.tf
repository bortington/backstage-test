# data "docker_registry_image" "ubuntu" {
#   name = "ubuntu:latest"
# }

data "azurerm_dns_zone" "badbort" {
  name                = "badbort.com"
  resource_group_name = "rg-common"
}

resource "azurerm_container_group" "cg" {
  name                = "aci-backstage"
  location            = azurerm_resource_group.rg_backstage.location
  resource_group_name = azurerm_resource_group.rg_backstage.name
  ip_address_type     = "Public"
  dns_name_label      = "backstage"
  os_type             = "Linux"

  container {
    name   = "backstage"
    image  = "registry.hub.docker.com/bortos/fredstage:latest"
    cpu    = "0.5"
    memory = "1"

    ports {
      port     = 7007
      protocol = "TCP"
    }

    secure_environment_variables = {
      GITHUB_TOKEN              = var.GITHUB_TOKEN
      AUTH_GITHUB_CLIENT_ID     = var.AUTH_GITHUB_CLIENT_ID
      AUTH_GITHUB_CLIENT_SECRET = var.AUTH_GITHUB_CLIENT_SECRET
    }
  }
}

resource "azurerm_dns_cname_record" "example" {
  name                = "backstage"
  zone_name           = data.azurerm_dns_zone.badbort.name
  resource_group_name = data.azurerm_dns_zone.badbort.resource_group_name
  ttl                 = 300
  record              = azurerm_container_group.cg.fqdn
}