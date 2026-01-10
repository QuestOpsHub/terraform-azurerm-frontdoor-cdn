#-----------------------------
# CDN Front Door Origin Group
#-----------------------------
resource "azurerm_cdn_frontdoor_origin_group" "cdn_frontdoor_origin_group" {
  for_each                 = var.cdn_frontdoor_origin_group
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id

  dynamic "load_balancing" {
    for_each = lookup(each.value, "load_balancing", null) != null ? [each.value.load_balancing] : []
    content {
      additional_latency_in_milliseconds = lookup(load_balancing.value, "additional_latency_in_milliseconds", 50)
      sample_size                        = lookup(load_balancing.value, "sample_size", 4)
      successful_samples_required        = lookup(load_balancing.value, "successful_samples_required", 3)
    }
  }

  dynamic "health_probe" {
    for_each = lookup(each.value, "health_probe", null) != null ? [each.value.health_probe] : []
    content {
      protocol            = health_probe.value.protocol
      interval_in_seconds = health_probe.value.interval_in_seconds
      request_type        = lookup(health_probe.value, "request_type", "HEAD")
      path                = lookup(health_probe.value, "path", "/")
    }
  }

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = lookup(each.value, "restore_traffic_time_to_healed_or_new_endpoint_in_minutes", 10)
  session_affinity_enabled                                  = lookup(each.value, "session_affinity_enabled", true)
}

#-----------------------
# CDN Front Door Origin
#-----------------------
resource "azurerm_cdn_frontdoor_origin" "cdn_frontdoor_origin" {
  for_each                       = var.cdn_frontdoor_origin
  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.cdn_frontdoor_origin_group[each.value.origin_group].id
  host_name                      = each.value.host_name
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  enabled                        = lookup(each.value, "enabled", true)
  http_port                      = lookup(each.value, "http_port", 80)
  https_port                     = lookup(each.value, "https_port", 443)
  origin_host_header             = lookup(each.value, "origin_host_header", null)
  priority                       = lookup(each.value, "priority", 1)

  dynamic "private_link" {
    for_each = lookup(each.value, "private_link", null) != null ? [each.value.private_link] : []
    content {
      request_message        = lookup(private_link.value, "request_message", "Access request for CDN FrontDoor Private Link Origin")
      target_type            = lookup(private_link.value, "target_type", null)
      location               = private_link.value.location
      private_link_target_id = private_link.value.private_link_target_id
    }
  }

  weight = lookup(each.value, "weight", 500)
}