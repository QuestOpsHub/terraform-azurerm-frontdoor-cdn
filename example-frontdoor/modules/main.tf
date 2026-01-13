locals {
  domain_endpoint_fqdn_map = distinct(flatten([
    for route in var.frontdoor_route : [
      for dom in route.domain : {
        endpoint = route.endpoint
        domain   = var.frontdoor_custom_domain[dom].host_name
      }
    ]
  ]))
}

#---------------
# Frontdoor profile
#---------------
resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = var.frontdoor_sku_name
}

#-------------------
# frontdoor endpoint
#-------------------
resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  for_each                 = var.frontdoor_endpoint
  name                     = each.value.frontdoor_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

#-----------------------
# frontdoor origin group
#-----------------------
resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  for_each                 = var.frontdoor_origin_group
  name                     = each.value.origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = try(each.value.session_enabled, true)

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = try(each.value.time_healed_mins, 10)

  health_probe {
    interval_in_seconds = try(each.value.interval_seconds, 240)
    path                = try(each.value.path, "/")
    protocol            = try(each.value.protocol, "Https")
    request_type        = try(each.value.request_type, "GET")
  }

  load_balancing {
    additional_latency_in_milliseconds = try(each.value.add_latency_milliseconds, 0)
    sample_size                        = try(each.value.sample_size, 16)
    successful_samples_required        = try(each.value.successful_samples_required, 3)
  }
}

#-----------------
# frontdoor origin
#-----------------
resource "azurerm_cdn_frontdoor_origin" "origin" {
  for_each                      = var.frontdoor_origin
  name                          = each.value.origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group[each.value.origin_group].id
  enabled                       = try(each.value.origin_enabled, true)

  certificate_name_check_enabled = each.value.certname_check_enabled

  host_name          = each.value.host_name
  http_port          = try(each.value.http_port, 80)
  https_port         = try(each.value.https_port, 443)
  origin_host_header = each.value.origin_host_header
  priority           = each.value.priority
  weight             = each.value.weight

  dynamic "private_link" {
    for_each = try(each.value.private_link_target_id, null) != null ? [each.value.private_link_target_id] : []
    content {
      private_link_target_id = var.remote_state_storage[element(split(":", each.value.private_link_target_id), 0)].outputs[split(":", each.value.private_link_target_id)[1]]
      location               = each.value.link_location
      target_type            = each.value.target_type
      request_message        = "Terraform Front Door origin"
    }
  }
}

#------------------------------
# custom domain and association
#------------------------------
resource "azurerm_cdn_frontdoor_custom_domain" "domain" {
  for_each                 = var.frontdoor_custom_domain
  name                     = each.value.custom_domain_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  host_name                = each.value.host_name
  tls {
    certificate_type    = try(each.value.certificate_type, "ManagedCertificate")
    minimum_tls_version = try(each.value.minimum_tls_version, "TLS12")
  }

  lifecycle {
    ignore_changes = [
      dns_zone_id, # Hack to prevent replacement of manually imported domain
    ]
  }
}

/* resource "azurerm_cdn_frontdoor_custom_domain_association" "contoso" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.contoso[each.value.contoso].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.frontdoor_route[each.value.frontdoor_route].id]
} */

#---------
# ruleset
#---------
resource "azurerm_cdn_frontdoor_rule_set" "rule_set" {
  for_each                 = var.rule_set
  name                     = each.value.rule_set_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

#-------
# rules
#-------
/* resource "azurerm_cdn_frontdoor_rule" "rule" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.origin_group, azurerm_cdn_frontdoor_origin.origin]

  name                      = "examplerule"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.rule_set.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    route_configuration_override_action {
      cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
      forwarding_protocol           = "HttpsOnly"
      query_string_caching_behavior = "IncludeSpecifiedQueryStrings"
      query_string_parameters       = ["foo", "clientIp={client_ip}"]
      compression_enabled           = true
      cache_behavior                = "OverrideIfOriginMissing"
      cache_duration                = "365.23:59:59"
    }

    url_redirect_action {
      redirect_type        = "PermanentRedirect"
      redirect_protocol    = "MatchRequest"
      query_string         = "clientIp={client_ip}"
      destination_path     = "/exampleredirection"
      destination_hostname = "contoso.com"
      destination_fragment = "UrlRedirect"
    }
  }

  conditions {
    host_name_condition {
      operator         = "Equal"
      negate_condition = false
      match_values     = ["www.contoso.com", "images.contoso.com", "video.contoso.com"]
      transforms       = ["Lowercase", "Trim"]
    }

    is_device_condition {
      operator         = "Equal"
      negate_condition = false
      match_values     = ["Mobile"]
    }

    post_args_condition {
      post_args_name = "customerName"
      operator       = "BeginsWith"
      match_values   = ["J", "K"]
      transforms     = ["Uppercase"]
    }

    request_method_condition {
      operator         = "Equal"
      negate_condition = false
      match_values     = ["DELETE"]
    }

    url_filename_condition {
      operator         = "Equal"
      negate_condition = false
      match_values     = ["media.mp4"]
      transforms       = ["Lowercase", "RemoveNulls", "Trim"]
    }
  }
} */

#----------------
# frontdoor route
#----------------
resource "azurerm_cdn_frontdoor_route" "frontdoor_route" {
  for_each                      = var.frontdoor_route
  name                          = each.value.frontdoor_route_name
  enabled                       = each.value.frontdoor_route_enabled
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint[each.value.endpoint].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group[each.value.origin_group].id
  cdn_frontdoor_rule_set_ids    = try(each.value.rule_set, null) != null ? [azurerm_cdn_frontdoor_rule_set.rule_set[each.value.rule_set].id] : null
  cdn_frontdoor_origin_ids      = length(each.value.origin) == 1 ? [azurerm_cdn_frontdoor_origin.origin[each.value.origin[0]].id] : [azurerm_cdn_frontdoor_origin.origin[each.value.origin[0]].id, azurerm_cdn_frontdoor_origin.origin[each.value.origin[1]].id]
  cdn_frontdoor_origin_path     = try(each.value.origin_path, null)
  forwarding_protocol           = each.value.forwarding_protocol
  https_redirect_enabled        = each.value.https_redirect_enabled
  patterns_to_match             = each.value.patterns_to_match
  supported_protocols           = each.value.supported_protocols

  cdn_frontdoor_custom_domain_ids = try(each.value.domain, null) != null ? [for domain in each.value.domain : azurerm_cdn_frontdoor_custom_domain.domain[domain].id] : null
  link_to_default_domain          = each.value.link_to_default_domain

  dynamic "cache" {
    for_each = lookup(each.value, "cache_enabled", false) == true ? [each.value] : []
    content {
      query_string_caching_behavior = cache.value.query_string_caching_behavior
      query_strings                 = cache.value.query_settings
      compression_enabled           = cache.value.compression_enabled
      content_types_to_compress     = cache.value.content_types_to_compress
    }
  }

  depends_on = [
    azurerm_cdn_frontdoor_endpoint.endpoint,
    azurerm_cdn_frontdoor_origin_group.origin_group,
    azurerm_cdn_frontdoor_rule_set.rule_set,
    azurerm_cdn_frontdoor_origin_group.origin_group,
    azurerm_cdn_frontdoor_origin.origin,
  ]
}

#---------------------
# Diagnostic Settings
#---------------------
data "azurerm_monitor_diagnostic_categories" "frontdoor_diagnostic_categories" {
  resource_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_monitor_diagnostic_setting" "frontdoor_diagnostic_setting" {
  count                          = var.enable_diagnostic_settings == true ? 1 : 0
  name                           = "diag-${azurerm_cdn_frontdoor_profile.frontdoor.name}"
  target_resource_id             = azurerm_cdn_frontdoor_profile.frontdoor.id
  log_analytics_workspace_id     = var.law_id
  log_analytics_destination_type = try(var.log_analytics_destination_type)

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.frontdoor_diagnostic_categories.log_category_types)

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.frontdoor_diagnostic_categories.metrics)

    content {
      category = metric.value
      enabled  = contains(var.metrics, metric.value)
    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}


# DNS CNAMEs

resource "azurerm_dns_cname_record" "frontdoor_endpoint_cname_record" {
  for_each = tomap({
    for entry in local.domain_endpoint_fqdn_map : "${entry.domain}.${entry.endpoint}" => entry
  })

  name                = replace(each.value.domain, ".${var.dns_zone_name}", "")
  zone_name           = var.dns_zone_name
  resource_group_name = var.zone_resource_group
  ttl                 = "300"
  record              = azurerm_cdn_frontdoor_endpoint.endpoint[each.value.endpoint].host_name
}

# DNS Validation

resource "azurerm_dns_txt_record" "frontdoor_domain_validation_record" {
  for_each            = var.frontdoor_custom_domain
  name                = format("_dnsauth.%s", replace(each.value.host_name, ".${var.dns_zone_name}", ""))
  zone_name           = var.dns_zone_name
  resource_group_name = var.zone_resource_group
  ttl                 = "300"
  record {
    value = azurerm_cdn_frontdoor_custom_domain.domain[each.key].validation_token
  }
}