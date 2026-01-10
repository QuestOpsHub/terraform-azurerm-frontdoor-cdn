#-------------------------
# CDN Front Door Rule Set
#-------------------------
resource "azurerm_cdn_frontdoor_rule_set" "cdn_frontdoor_rule_set" {
  for_each                 = var.cdn_frontdoor_rule_set
  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id
}

#---------------------
# CDN Front Door Rule
#---------------------
resource "azurerm_cdn_frontdoor_rule" "cdn_frontdoor_rule" {
  for_each                  = var.cdn_frontdoor_rule
  name                      = each.key
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.cdn_frontdoor_rule_set[each.value.cdn_frontdoor_rule_set].id
  order                     = each.value.order
  behavior_on_match         = lookup(each.value, "behavior_on_match", "Continue")

  actions {
    dynamic "url_rewrite_action" {
      for_each = lookup(each.value.actions, "url_rewrite_action", null) != null ? [each.value.actions.url_rewrite_action] : []
      content {
        source_pattern          = url_rewrite_action.value.source_pattern
        destination             = url_rewrite_action.value.destination
        preserve_unmatched_path = lookup(url_rewrite_action.value, "preserve_unmatched_path", null)
      }
    }

    dynamic "url_redirect_action" {
      for_each = lookup(each.value.actions, "url_redirect_action", null) != null ? [each.value.actions.url_redirect_action] : []
      content {
        redirect_type        = url_redirect_action.value.redirect_type
        destination_hostname = url_redirect_action.value.destination_hostname
        redirect_protocol    = lookup(url_redirect_action.value, "redirect_protocol", "MatchRequest")
        destination_path     = lookup(url_redirect_action.value, "destination_path", "")
        query_string         = lookup(url_redirect_action.value, "query_string", "")
        destination_fragment = lookup(url_redirect_action.value, "destination_fragment", "")
      }
    }

    dynamic "route_configuration_override_action" {
      for_each = lookup(each.value.actions, "route_configuration_override_action", null) != null ? [each.value.actions.route_configuration_override_action] : []
      content {
        cache_duration                = lookup(route_configuration_override_action.value, "cache_duration", null)
        cdn_frontdoor_origin_group_id = lookup(route_configuration_override_action.value, "cdn_frontdoor_origin_group_id", null)
        forwarding_protocol           = lookup(route_configuration_override_action.value, "forwarding_protocol", null)
        query_string_caching_behavior = lookup(route_configuration_override_action.value, "query_string_caching_behavior", null)
        query_string_parameters       = lookup(route_configuration_override_action.value, "query_string_parameters", [])
        compression_enabled           = lookup(route_configuration_override_action.value, "compression_enabled", null)
        cache_behavior                = lookup(route_configuration_override_action.value, "cache_behavior", null)
      }
    }

    dynamic "request_header_action" {
      for_each = lookup(each.value.actions, "request_header_action", null) != null ? [each.value.actions.request_header_action] : []
      content {
        header_action = request_header_action.value.header_action
        header_name   = request_header_action.value.header_name
        value         = lookup(request_header_action.value, "value", null)
      }
    }

    dynamic "response_header_action" {
      for_each = lookup(each.value.actions, "response_header_action", null) != null ? [each.value.actions.response_header_action] : []
      content {
        header_action = response_header_action.value.header_action
        header_name   = response_header_action.value.header_name
        value         = lookup(response_header_action.value, "value", null)
      }
    }
  }

  dynamic "conditions" {
    for_each = lookup(each.value, "conditions", null) != null ? [each.value.conditions] : []
    content {
      dynamic "remote_address_condition" {
        for_each = lookup(each.value.conditions, "remote_address_condition", null) != null ? [each.value.conditions.remote_address_condition] : []
        content {
          operator         = lookup(remote_address_condition.value, "operator", "IPMatch")
          negate_condition = lookup(remote_address_condition.value, "negate_condition", false)
          match_values     = lookup(remote_address_condition.value, "match_values", null)
        }
      }

      dynamic "request_method_condition" {
        for_each = lookup(each.value.conditions, "request_method_condition", null) != null ? [each.value.conditions.request_method_condition] : []
        content {
          operator         = lookup(request_method_condition.value, "operator", "Equal")
          negate_condition = lookup(request_method_condition.value, "negate_condition", false)
          match_values     = request_method_condition.value.match_values
        }
      }

      dynamic "query_string_condition" {
        for_each = lookup(each.value.conditions, "query_string_condition", null) != null ? [each.value.conditions.query_string_condition] : []
        content {
          operator         = query_string_condition.valueoperator
          negate_condition = lookup(query_string_condition.value, "negate_condition", false)
          match_values     = lookup(query_string_condition.value, "match_values", null)
        }
      }

      dynamic "post_args_condition" {
        for_each = lookup(each.value.conditions, "post_args_condition", null) != null ? [each.value.conditions.post_args_condition] : []
        content {
          post_args_name   = post_args_condition.value.post_args_name
          operator         = post_args_condition.value.operator
          negate_condition = lookup(post_args_condition.value, "negate_condition", false)
          match_values     = lookup(post_args_condition.value, "match_values", null)
          transforms       = lookup(post_args_condition.value, "transforms", null)
        }
      }

      dynamic "request_uri_condition" {
        for_each = lookup(each.value.conditions, "request_uri_condition", null) != null ? [each.value.conditions.request_uri_condition] : []
        content {
          operator         = request_uri_condition.value.operator
          negate_condition = lookup(request_uri_condition.value, "negate_condition", false)
          match_values     = lookup(request_uri_condition.value, "match_values", null)
          transforms       = lookup(request_uri_condition.value, "transforms", null)
        }
      }

      dynamic "request_header_condition" {
        for_each = lookup(each.value.conditions, "request_header_condition", null) != null ? [each.value.conditions.request_header_condition] : []
        content {
          header_name      = request_header_condition.value.header_name
          operator         = request_header_condition.value.operator
          negate_condition = lookup(request_header_condition.value, "negate_condition", false)
          match_values     = lookup(request_header_condition.value, "match_values", null)
          transforms       = lookup(request_header_condition.value, "transforms", null)
        }
      }

      dynamic "request_body_condition" {
        for_each = lookup(each.value.conditions, "request_body_condition", null) != null ? [each.value.conditions.request_body_condition] : []
        content {
          operator         = request_body_condition.value.operator
          negate_condition = lookup(request_body_condition.value, "negate_condition", false)
          match_values     = request_body_condition.value.match_values
          transforms       = lookup(request_body_condition.value, "transforms", null)
        }
      }

      dynamic "request_scheme_condition" {
        for_each = lookup(each.value.conditions, "request_scheme_condition", null) != null ? [each.value.conditions.request_scheme_condition] : []
        content {
          operator         = lookup(request_scheme_condition.value, "operator", "Equal")
          negate_condition = lookup(request_scheme_condition.value, "negate_condition", false)
          match_values     = lookup(request_scheme_condition.value, "match_values", null)
        }
      }

      dynamic "url_path_condition" {
        for_each = lookup(each.value.conditions, "url_path_condition", null) != null ? [each.value.conditions.url_path_condition] : []
        content {
          operator         = url_path_condition.value.operator
          negate_condition = lookup(url_path_condition.value, "negate_condition", false)
          match_values     = lookup(url_path_condition.value, "match_values", null)
          transforms       = lookup(url_path_condition.value, "transforms", null)
        }
      }

      dynamic "url_file_extension_condition" {
        for_each = lookup(each.value.conditions, "url_file_extension_condition", null) != null ? [each.value.conditions.url_file_extension_condition] : []
        content {
          operator         = url_file_extension_condition.value.operator
          negate_condition = lookup(url_file_extension_condition.value, "negate_condition", false)
          match_values     = url_file_extension_condition.value.match_values
          transforms       = lookup(url_file_extension_condition.value, "transforms", null)
        }
      }

      dynamic "url_filename_condition" {
        for_each = lookup(each.value.conditions, "url_filename_condition", null) != null ? [each.value.conditions.url_filename_condition] : []
        content {
          operator         = url_filename_condition.value.operator
          negate_condition = lookup(url_filename_condition.value, "negate_condition", false)
          match_values     = lookup(url_filename_condition.value, "match_values", null)
          transforms       = lookup(url_filename_condition.value, "transforms", null)
        }
      }

      dynamic "http_version_condition" {
        for_each = lookup(each.value.conditions, "http_version_condition", null) != null ? [each.value.conditions.http_version_condition] : []
        content {
          operator         = lookup(http_version_condition.value, "operator", "Equal")
          negate_condition = lookup(http_version_condition.value, "negate_condition", false)
          match_values     = http_version_condition.value.match_values
        }
      }

      dynamic "cookies_condition" {
        for_each = lookup(each.value.conditions, "cookies_condition", null) != null ? [each.value.conditions.cookies_condition] : []
        content {
          cookie_name      = cookies_condition.value.cookie_name
          operator         = cookies_condition.value.operator
          negate_condition = lookup(cookies_condition.value, "negate_condition", false)
          match_values     = lookup(cookies_condition.value, "match_values", null)
          transforms       = lookup(cookies_condition.value, "transforms", null)
        }
      }

      dynamic "is_device_condition" {
        for_each = lookup(each.value.conditions, "is_device_condition", null) != null ? [each.value.conditions.is_device_condition] : []
        content {
          operator         = lookup(is_device_condition.value, "operator", "Equal")
          negate_condition = lookup(is_device_condition.value, "negate_condition", false)
          match_values     = lookup(is_device_condition.value, "match_values", null)
        }
      }
    }
  }
}