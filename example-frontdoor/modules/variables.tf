variable "frontdoor_name" {}

variable "frontdoor_sku_name" {}

variable "resource_group_name" {}

variable "frontdoor_endpoint" {}

variable "frontdoor_origin_group" {}

variable "frontdoor_origin" {}

variable "frontdoor_custom_domain" {}

variable "rule_set" {}

variable "frontdoor_route" {}

variable "remote_state_storage" {}

#------------------
# DNS Zone Settings
#------------------
variable "dns_zone_name" {}

variable "zone_resource_group" {}

#---------------------
# Diagnostic Settings
#---------------------
variable "enable_diagnostic_settings" {
  default = true
}

variable "law_id" {}

variable "log_analytics_destination_type" {
  default = null
}

variable "log_category_types" {}

variable "metrics" {}

variable "retention_days" {
  default = 30
}

