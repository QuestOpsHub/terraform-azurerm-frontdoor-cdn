#------------------------
# CDN Front Door Profile
#------------------------
resource "azurerm_cdn_frontdoor_profile" "cdn_frontdoor_profile" {
  name                     = var.cdn_frontdoor_profile_name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = try(var.response_timeout_seconds, 120)

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["creation_timestamp"],
    ]
  }
}