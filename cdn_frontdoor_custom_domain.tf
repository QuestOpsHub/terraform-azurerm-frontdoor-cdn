#------------------------------
# CDN Front Door Custom Domain
#------------------------------
resource "azurerm_cdn_frontdoor_custom_domain" "cdn_frontdoor_custom_domain" {
  for_each                 = var.cdn_frontdoor_custom_domain
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id
  host_name                = each.value.host_name
  dns_zone_id              = lookup(each.value, "dns_zone_id", null)

  dynamic "tls" {
    for_each = lookup(each.value, "tls", null) != null ? [each.value.tls] : []
    content {
      certificate_type        = lookup(tls.value, "certificate_type", "ManagedCertificate")
      minimum_tls_version     = lookup(tls.value, "minimum_tls_version", "TLS12")
      cdn_frontdoor_secret_id = lookup(tls.value, "cdn_frontdoor_secret_id", null)
    }
  }
}

#------------------------------------------
# CDN Front Door Custom Domain Association
#------------------------------------------
resource "azurerm_cdn_frontdoor_custom_domain_association" "cdn_frontdoor_custom_domain_association" {
  for_each                       = var.cdn_frontdoor_custom_domain_association
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.cdn_frontdoor_custom_domain[each.value.domain].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.cdn_frontdoor_route[each.value.route].id]
}