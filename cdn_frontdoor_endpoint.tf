#-------------------------
# CDN Front Door Endpoint
#-------------------------
resource "azurerm_cdn_frontdoor_endpoint" "cdn_frontdoor_endpoint" {
  for_each                 = var.cdn_frontdoor_endpoint
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id
  enabled                  = lookup(each.value, "enabled", true)

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["creation_timestamp"],
    ]
  }
}