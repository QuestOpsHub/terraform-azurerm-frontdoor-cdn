#-----------
# Front Door
#-----------
module "front_door" {
  source = "../../modules/frontdoor"

  remote_state_storage = data.terraform_remote_state.spoke
  resource_group_name  = module.resource_group[var.frontdoor.resource_group].name
  frontdoor_name       = lower(var.frontdoor.frontdoor_name)
  frontdoor_sku_name   = var.frontdoor.frontdoor_sku_name
  frontdoor_endpoint   = var.frontdoor.frontdoor_endpoint
  # dns_zone                = var.frontdoor.dns_zone
  frontdoor_origin_group         = var.frontdoor.frontdoor_origin_group
  frontdoor_origin               = var.frontdoor.frontdoor_origin
  frontdoor_custom_domain        = var.frontdoor.frontdoor_custom_domain
  rule_set                       = var.frontdoor.rule_set
  frontdoor_route                = var.frontdoor.frontdoor_route
  law_id                         = data.terraform_remote_state.hub.outputs.law[var.frontdoor.law].id
  log_analytics_destination_type = try(var.frontdoor.log_analytics_destination_type, null)
  log_category_types             = var.frontdoor.log_category_types
  metrics                        = var.frontdoor.metrics
  retention_days                 = try(var.frontdoor.retention_days, 30)

  dns_zone_name       = var.dns_zone_name
  zone_resource_group = data.terraform_remote_state.hub.outputs.resource_group["networking"].name
}