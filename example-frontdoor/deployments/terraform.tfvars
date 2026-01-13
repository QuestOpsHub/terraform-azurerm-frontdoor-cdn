frontdoor = {
  resource_group     = "cdn"
  law                = "hub"
  frontdoor_name     = "afd-eedoc-hub-portal-01"
  frontdoor_sku_name = "Premium_AzureFrontDoor"
  frontdoor_endpoint = {
    na-portal-dev-eedoc = {
      frontdoor_endpoint_name = "afe-eedoc-hub-portal-westus2-dev-01"
    },
    na-portal-qa-eedoc = {
      frontdoor_endpoint_name = "afe-eedoc-hub-portal-westus2-qa-01"
    },
    na-portal-prod-eedoc = {
      frontdoor_endpoint_name = "afe-eedoc-hub-portal-westus2-prod-01"
    },
  }
  frontdoor_origin_group = {
    na-flashware-dev-eedoc = {
      origin_group_name = "na-flashware-dev-eedoc",
      request_type = "HEAD"
    },
    na-aks-dev-eedoc = {
      origin_group_name = "na-aks-dev-eedoc",
      request_type = "HEAD"
    },
    na-flashware-qa-eedoc = {
      origin_group_name = "na-flashware-qa-eedoc",
      request_type = "HEAD"
    },
    na-aks-qa-eedoc = {
      origin_group_name = "na-aks-qa-eedoc",
      request_type = "HEAD"
    },
    na-flashware-prod-eedoc = {
      origin_group_name = "na-flashware-prod-eedoc",
      request_type = "HEAD"
    },
    na-aks-prod-eedoc = {
      origin_group_name = "na-aks-prod-eedoc",
      request_type = "HEAD"
    },
  }

  frontdoor_origin = {
    na-flashware-dev-eedoc = {
      // Private Endpoint for flashware storage account
      origin_name            = "na-flashware-dev-eedoc"
      origin_group           = "na-flashware-dev-eedoc"
      certname_check_enabled = true
      priority               = 1
      weight                 = 1
      private_link_target_id = "westus2-dev:flashware_storage_account_id"
      link_location          = "westus3" # https://learn.microsoft.com/en-us/azure/frontdoor/private-link#region-availability
      target_type            = "blob"
      // #TODO - see if these can be made generic
      host_name          = "steedocdevwestus2fw01.blob.core.windows.net"
      origin_host_header = "steedocdevwestus2fw01.blob.core.windows.net"
    },
    na-aks-dev-eedoc = {
      // Azure Kubernetes Service
      origin_name            = "na-aks-dev-eedoc"
      origin_group           = "na-aks-dev-eedoc"
      certname_check_enabled = true
      priority               = 1
      weight                 = 1
      // #TODO - see if these can be made generic
      host_name              = "40.91.103.109"
      origin_host_header     = "ingress-nginx.dev.westus2.priv.eedoc.daimlertruck.com"
      http_port             = 8081
      https_port            = 443 # Not used
    }
    na-flashware-qa-eedoc = {
      // Private Endpoint for flashware storage account
      origin_name            = "na-flashware-qa-eedoc"
      origin_group           = "na-flashware-qa-eedoc"
      certname_check_enabled = true
      priority               = 1
      weight                 = 1
      private_link_target_id = "westus2-qa:flashware_storage_account_id"
      link_location          = "westus3" # https://learn.microsoft.com/en-us/azure/frontdoor/private-link#region-availability
      target_type            = "blob"
      // #TODO - see if these can be made generic
      host_name          = "steedocqawestus2fw01.blob.core.windows.net"
      origin_host_header = "steedocqawestus2fw01.blob.core.windows.net"
    },
    na-aks-qa-eedoc = {
      // Azure Kubernetes Service
      origin_name            = "na-aks-qa-eedoc"
      origin_group           = "na-aks-qa-eedoc"
      certname_check_enabled = true
      priority               = 1
      weight                 = 1
      // #TODO - see if these can be made generic
      host_name              = "40.91.103.109"
      origin_host_header     = "ingress-nginx.qa.westus2.priv.eedoc.daimlertruck.com"
      http_port             = 8082
      https_port            = 443 # Not used
    }
    na-flashware-prod-eedoc = {
      // Private Endpoint for flashware storage account
      origin_name            = "na-flashware-prod-eedoc"
      origin_group           = "na-flashware-prod-eedoc"
      certname_check_enabled = true
      priority               = 1
      weight                 = 1
      private_link_target_id = "westus2-prod:flashware_storage_account_id"
      link_location          = "westus3" # https://learn.microsoft.com/en-us/azure/frontdoor/private-link#region-availability
      target_type            = "blob"
      // #TODO - see if these can be made generic
      host_name          = "steedocprodwestus2fw01.blob.core.windows.net"
      origin_host_header = "steedocprodwestus2fw01.blob.core.windows.net"
    },
    na-aks-prod-eedoc = {
      // Azure Kubernetes Service
      origin_name            = "na-aks-prod-eedoc"
      origin_group           = "na-aks-prod-eedoc"
      certname_check_enabled = true
      priority               = 1
      weight                 = 1
      // #TODO - see if these can be made generic
      host_name              = "40.91.103.109"
      origin_host_header     = "ingress-nginx.prod.westus2.priv.eedoc.daimlertruck.com"
      http_port             = 8083
      https_port            = 443 # Not used
    }
  }

  frontdoor_custom_domain = {
    portal-dev-eedoc = {
      custom_domain_name  = "dev-eedoc-daimlertruck-com"
      host_name           = "dev.eedoc.daimlertruck.com"
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    },
    na-portal-dev-eedoc = {
      custom_domain_name  = "na-dev-eedoc-daimlertruck-com"
      host_name           = "na.dev.eedoc.daimlertruck.com"
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }
    portal-qa-eedoc = {
      custom_domain_name  = "qa-eedoc-daimlertruck-com"
      host_name           = "qa.eedoc.daimlertruck.com"
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    },
    na-portal-qa-eedoc = {
      custom_domain_name  = "na-qa-eedoc-daimlertruck-com"
      host_name           = "na.qa.eedoc.daimlertruck.com"
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }
    portal-prod-eedoc = {
      custom_domain_name  = "eedoc-daimlertruck-com-e89b" # Manually created in Az Portal as an apex domain and then imported
      host_name           = "eedoc.daimlertruck.com"
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    },
    na-portal-prod-eedoc = {
      custom_domain_name  = "na-eedoc-daimlertruck-com"
      host_name           = "na.eedoc.daimlertruck.com"
      certificate_type    = "ManagedCertificate"
      minimum_tls_version = "TLS12"
    }
  }

  rule_set = {}

  frontdoor_route = {
    ### DEV - all regions ###
    aks-dev = {
      frontdoor_route_name          = "aks-dev"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "HttpOnly"
      https_redirect_enabled        = false
      patterns_to_match             = ["/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-dev-eedoc"
      origin_group                  = "na-aks-dev-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-dev-eedoc"] # Extend to other region origins in future
      domain                        = ["portal-dev-eedoc"]
    }
    storage-dev = {
      frontdoor_route_name          = "storage-dev"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "MatchRequest"
      https_redirect_enabled        = true
      patterns_to_match             = ["/storage/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-dev-eedoc"
      origin_group                  = "na-flashware-dev-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-dev-eedoc"] # Extend to other region origins in future
      domain                        = ["portal-dev-eedoc"]
    }
    ### QA - all regions ###
    aks-qa = {
      frontdoor_route_name          = "aks-qa"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "HttpOnly"
      https_redirect_enabled        = false
      patterns_to_match             = ["/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-qa-eedoc"
      origin_group                  = "na-aks-qa-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-qa-eedoc"] # Extend to other region origins in future
      domain                        = ["portal-qa-eedoc"]
    }
    storage-qa = {
      frontdoor_route_name          = "storage-qa"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "MatchRequest"
      https_redirect_enabled        = true
      patterns_to_match             = ["/storage/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-qa-eedoc"
      origin_group                  = "na-flashware-qa-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-qa-eedoc"] # Extend to other region origins in future
      domain                        = ["portal-qa-eedoc"]
    }
    ### Prod - all regions ###
    aks-prod = {
      frontdoor_route_name          = "aks-prod"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "HttpOnly"
      https_redirect_enabled        = false
      patterns_to_match             = ["/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-prod-eedoc"
      origin_group                  = "na-aks-prod-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-prod-eedoc"] # Extend to other region origins in future
      domain                        = ["portal-prod-eedoc"]
    }
    storage-prod = {
      frontdoor_route_name          = "storage-prod"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "MatchRequest"
      https_redirect_enabled        = true
      patterns_to_match             = ["/storage/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-prod-eedoc"
      origin_group                  = "na-flashware-prod-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-prod-eedoc"] # Extend to other region origins in future
      domain                        = ["portal-prod-eedoc"]
    }
    ### DEV - North America ###
    na-aks-dev = {
      frontdoor_route_name          = "na-aks-dev"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "HttpOnly"
      https_redirect_enabled        = false
      patterns_to_match             = ["/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-dev-eedoc"
      origin_group                  = "na-aks-dev-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-dev-eedoc"]
      domain                        = ["na-portal-dev-eedoc"]
    }
    na-storage-dev = {
      frontdoor_route_name          = "na-storage-dev"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "MatchRequest"
      https_redirect_enabled        = true
      patterns_to_match             = ["/storage/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-dev-eedoc"
      origin_group                  = "na-flashware-dev-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-dev-eedoc"]
      domain                        = ["na-portal-dev-eedoc"]
    }
    ### QA - North America ###
    na-aks-qa = {
      frontdoor_route_name          = "na-aks-qa"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "HttpOnly"
      https_redirect_enabled        = false
      patterns_to_match             = ["/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-qa-eedoc"
      origin_group                  = "na-aks-qa-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-qa-eedoc"]
      domain                        = ["na-portal-qa-eedoc"]
    }
    na-storage-qa = {
      frontdoor_route_name          = "na-storage-qa"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "MatchRequest"
      https_redirect_enabled        = true
      patterns_to_match             = ["/storage/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-qa-eedoc"
      origin_group                  = "na-flashware-qa-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-qa-eedoc"]
      domain                        = ["na-portal-qa-eedoc"]
    }
    ### Prod - North America ###
    na-aks-prod = {
      frontdoor_route_name          = "na-aks-prod"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "HttpOnly"
      https_redirect_enabled        = false
      patterns_to_match             = ["/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-prod-eedoc"
      origin_group                  = "na-aks-prod-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-prod-eedoc"]
      domain                        = ["na-portal-prod-eedoc"]
    }
    na-storage-prod = {
      frontdoor_route_name          = "na-storage-prod"
      frontdoor_route_enabled       = true
      forwarding_protocol           = "MatchRequest"
      https_redirect_enabled        = true
      patterns_to_match             = ["/storage/*"]
      supported_protocols           = ["Http", "Https"]
      link_to_default_domain        = false
      cache_enabled                 = false
      query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
      query_settings                = ["account", "settings"]
      compression_enabled           = true
      content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
      endpoint                      = "na-portal-prod-eedoc"
      origin_group                  = "na-flashware-prod-eedoc"
      origin_path                   = "/"
      origin                        = ["na-flashware-prod-eedoc"]
      domain                        = ["na-portal-prod-eedoc"]
    }
  }

  log_category_types = ["AuditEvent"]
  metrics            = ["AllMetrics"]
}