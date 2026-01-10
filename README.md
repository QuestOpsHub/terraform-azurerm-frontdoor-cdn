## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_custom_domain.cdn_frontdoor_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain_association.cdn_frontdoor_custom_domain_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain_association) | resource |
| [azurerm_cdn_frontdoor_endpoint.cdn_frontdoor_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_origin.cdn_frontdoor_origin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.cdn_frontdoor_origin_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.cdn_frontdoor_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_rule.cdn_frontdoor_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule) | resource |
| [azurerm_cdn_frontdoor_rule_set.cdn_frontdoor_rule_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set) | resource |
| [azurerm_dns_cname_record.dns_cname_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_txt_record.frontdoor_domain_validation_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cdn_frontdoor_custom_domain"></a> [cdn\_frontdoor\_custom\_domain](#input\_cdn\_frontdoor\_custom\_domain) | ------------------------------ CDN Front Door Custom Domain ------------------------------ | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_custom_domain_association"></a> [cdn\_frontdoor\_custom\_domain\_association](#input\_cdn\_frontdoor\_custom\_domain\_association) | ------------------------------------------ CDN Front Door Custom Domain Association ------------------------------------------ | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_endpoint"></a> [cdn\_frontdoor\_endpoint](#input\_cdn\_frontdoor\_endpoint) | ------------------------- CDN Front Door Endpoint ------------------------- | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_origin"></a> [cdn\_frontdoor\_origin](#input\_cdn\_frontdoor\_origin) | ----------------------- CDN Front Door Origin ----------------------- | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_origin_group"></a> [cdn\_frontdoor\_origin\_group](#input\_cdn\_frontdoor\_origin\_group) | ----------------------------- CDN Front Door Origin Group ----------------------------- | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_profile_name"></a> [cdn\_frontdoor\_profile\_name](#input\_cdn\_frontdoor\_profile\_name) | (Required) Specifies the name of the Front Door Profile. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_cdn_frontdoor_route"></a> [cdn\_frontdoor\_route](#input\_cdn\_frontdoor\_route) | ---------------------- CDN Front Door Route ---------------------- | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_rule"></a> [cdn\_frontdoor\_rule](#input\_cdn\_frontdoor\_rule) | --------------------- CDN Front Door Rule --------------------- | `map` | `{}` | no |
| <a name="input_cdn_frontdoor_rule_set"></a> [cdn\_frontdoor\_rule\_set](#input\_cdn\_frontdoor\_rule\_set) | ------------------------- CDN Front Door Rule Set ------------------------- | `map` | `{}` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | ---------------------- Dns cname txt record ---------------------- | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where this Front Door Profile should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_response_timeout_seconds"></a> [response\_timeout\_seconds](#input\_response\_timeout\_seconds) | (Optional) Specifies the maximum response timeout in seconds. Possible values are between 16 and 240 seconds (inclusive). Defaults to 120 seconds. | `number` | `120` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) Specifies the SKU for this Front Door Profile. Possible values include Standard\_AzureFrontDoor and Premium\_AzureFrontDoor. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(any)` | `{}` | no |
| <a name="input_zone_resource_group"></a> [zone\_resource\_group](#input\_zone\_resource\_group) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
