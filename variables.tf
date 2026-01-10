#------------------------------
# CDN Front Door Custom Domain
#------------------------------
variable "cdn_frontdoor_custom_domain" {
  default = {}
}

#------------------------------------------
# CDN Front Door Custom Domain Association
#------------------------------------------
variable "cdn_frontdoor_custom_domain_association" {
  default = {}
}

#-------------------------
# CDN Front Door Endpoint
#-------------------------
variable "cdn_frontdoor_endpoint" {
  default = {}
}

#-----------------------------
# CDN Front Door Origin Group
#-----------------------------
variable "cdn_frontdoor_origin_group" {
  default = {}
}

#-----------------------
# CDN Front Door Origin
#-----------------------
variable "cdn_frontdoor_origin" {
  default = {}
}

#------------------------
# CDN Front Door Profile
#------------------------
variable "cdn_frontdoor_profile_name" {
  description = "(Required) Specifies the name of the Front Door Profile. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where this Front Door Profile should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "sku_name" {
  description = "(Required) Specifies the SKU for this Front Door Profile. Possible values include Standard_AzureFrontDoor and Premium_AzureFrontDoor. Changing this forces a new resource to be created."
  type        = string
}

variable "response_timeout_seconds" {
  description = "(Optional) Specifies the maximum response timeout in seconds. Possible values are between 16 and 240 seconds (inclusive). Defaults to 120 seconds."
  type        = number
  default     = 120
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}

#----------------------
# CDN Front Door Route
#----------------------
variable "cdn_frontdoor_route" {
  default = {}
}

#-------------------------
# CDN Front Door Rule Set
#-------------------------
variable "cdn_frontdoor_rule_set" {
  default = {}
}

#---------------------
# CDN Front Door Rule
#---------------------
variable "cdn_frontdoor_rule" {
  default = {}
}

#----------------------
# Dns cname txt record
#----------------------
variable "dns_zone_name" {}

variable "zone_resource_group" {}