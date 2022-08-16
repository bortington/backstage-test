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
    memory = "0.5"

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

  container {
    name   = "caddy"
    image  = "caddy"
    cpu    = "0.5"
    memory = "0.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    ports {
      port     = 443
      protocol = "TCP"
    }

    volume {
      name                 = "aci-caddy-data"
      mount_path           = "/data"
      storage_account_name = azurerm_storage_account.sta.name
      storage_account_key  = azurerm_storage_account.sta.primary_access_key
      share_name           = azurerm_storage_share.caddy_sc.name
    }

    # commands = ["caddy", "reverse-proxy", "--from", "backstage.australiaeast.azurecontainer.io", "--to", "localhost:7007"]
    commands = ["caddy", "reverse-proxy", "--from", "backstage.badbort.com", "--to", "localhost:7007"]
  }
}

resource "azurerm_dns_cname_record" "example" {
  name                = "backstage"
  zone_name           = data.azurerm_dns_zone.badbort.name
  resource_group_name = data.azurerm_dns_zone.badbort.resource_group_name
  ttl                 = 300
  record              = azurerm_container_group.cg.fqdn
}