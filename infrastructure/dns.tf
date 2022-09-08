data "azurerm_dns_zone" "this" {
  name                = var.dns_zone_name
  resource_group_name = var.dns_resource_group
}

resource "azurerm_dns_cname_record" "example" {
  name                = "backstage"
  zone_name           = data.azurerm_dns_zone.this.name
  resource_group_name = data.azurerm_dns_zone.this.resource_group_name
  ttl                 = 300
  record              = azurerm_container_group.cg.fqdn
}