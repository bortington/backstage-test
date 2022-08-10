# data "docker_registry_image" "ubuntu" {
#   name = "ubuntu:latest"
# }

data "azurerm_dns_zone" "badbort" {
  name                = "badbort.com"
  resource_group_name = "rg-common"
}

resource "azurerm_container_group" "cg" {
  name                = "mycontainer"
  location            = azurerm_resource_group.rg_backstage.location
  resource_group_name = azurerm_resource_group.rg_backstage.name
  ip_address_type     = "Public"
  dns_name_label      = "bortacusmaximus"
  os_type             = "Linux"

  container {
    name   = "testsite"
    image  = "registry.hub.docker.com/bortos/fredstage:latest"
    cpu    = "0.5"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

resource "azurerm_dns_cname_record" "example" {
  name                = "www"
  zone_name           = data.azurerm_dns_zone.badbort.name
  resource_group_name = data.azurerm_dns_zone.badbort.resource_group_name
  ttl                 = 300
  record              = azurerm_container_group.cg.fqdn
}