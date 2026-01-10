#----------------------
# CDN Front Door Route
#----------------------
resource "azurerm_cdn_frontdoor_route" "cdn_frontdoor_route" {
  for_each                      = var.cdn_frontdoor_route
  name                          = each.value.name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.cdn_frontdoor_endpoint[each.value.endpoint].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.cdn_frontdoor_origin_group[each.value.origin_group].id
  cdn_frontdoor_origin_ids      = length(each.value.origin) == 1 ? [azurerm_cdn_frontdoor_origin.cdn_frontdoor_origin[each.value.origin[0]].id] : [azurerm_cdn_frontdoor_origin.cdn_frontdoor_origin[each.value.origin[0]].id, azurerm_cdn_frontdoor_origin.cdn_frontdoor_origin[each.value.origin[1]].id]
  forwarding_protocol           = lookup(each.value, "forwarding_protocol", null)
  patterns_to_match             = each.value.patterns_to_match
  supported_protocols           = each.value.supported_protocols

  dynamic "cache" {
    for_each = lookup(each.value, "cache", null) != null ? [each.value.cache] : []
    content {
      query_string_caching_behavior = lookup(cache.value, "query_string_caching_behavior", "IgnoreQueryString")
      query_strings                 = lookup(cache.value, "query_strings", null)
      compression_enabled           = lookup(cache.value, "compression_enabled", false)
      content_types_to_compress     = lookup(cache.value, "content_types_to_compress", null)
    }
  }

  cdn_frontdoor_custom_domain_ids = lookup(each.value, "domain", null) != null ? [for domain in each.value.domain : azurerm_cdn_frontdoor_custom_domain.cdn_frontdoor_custom_domain[domain].id] : null
  cdn_frontdoor_origin_path       = lookup(each.value, "cdn_frontdoor_origin_path", null)
  cdn_frontdoor_rule_set_ids      = lookup(each.value, "rule_set", null) != null ? [azurerm_cdn_frontdoor_rule_set.cdn_frontdoor_rule_set[each.value.rule_set].id] : null
  enabled                         = lookup(each.value, "enabled", true)
  https_redirect_enabled          = lookup(each.value, "https_redirect_enabled", true)
  link_to_default_domain          = lookup(each.value, "link_to_default_domain", true)
}