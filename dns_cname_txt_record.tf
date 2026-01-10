#----------------------
# Dns cname txt record
#----------------------
locals {
  domain_endpoint_fqdn_map = distinct(flatten([
    for route in var.cdn_frontdoor_route : [
      for dom in route.domain : {
        endpoint = route.endpoint
        domain   = var.cdn_frontdoor_custom_domain[dom].host_name
      }
    ]
  ]))
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  for_each = tomap({
    for entry in local.domain_endpoint_fqdn_map : "${entry.domain}.${entry.endpoint}" => entry
  })
  name                = replace(each.value.domain, ".${var.dns_zone_name}", "")
  zone_name           = var.dns_zone_name
  resource_group_name = var.zone_resource_group
  ttl                 = "300"
  record              = azurerm_cdn_frontdoor_endpoint.cdn_frontdoor_endpoint[each.value.endpoint].host_name
}

resource "azurerm_dns_txt_record" "frontdoor_domain_validation_record" {
  for_each            = var.cdn_frontdoor_custom_domain
  name                = format("_dnsauth.%s", replace(each.value.host_name, ".${var.dns_zone_name}", ""))
  zone_name           = var.dns_zone_name
  resource_group_name = var.zone_resource_group
  ttl                 = "300"
  record {
    value = azurerm_cdn_frontdoor_custom_domain.cdn_frontdoor_custom_domain[each.key].validation_token
  }
}