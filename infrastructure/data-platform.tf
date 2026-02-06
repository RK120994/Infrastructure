data "azurerm_resource_group" "rg" {
   name     = var.resource_group_name
   #location = "South Africa North"
 }
 data "azurerm_resource_group" "apim_rg" {
   name     = var.apim_resource_group_name
   #location = "South Africa North"
 }
data "azurerm_api_management" "apim_internal" {
   name                = var.apim_instance_name
   resource_group_name = data.azurerm_resource_group.apim_rg.name
 }
 data "azurerm_api_management_product" "integration_apim_internal_api_product" {
 depends_on = [
    azurerm_api_management_product.integration_apim_product
  ]
  product_id          = "${var.stage}-integration-apim-product"
  api_management_name = data.azurerm_api_management.apim_internal.name
  resource_group_name = data.azurerm_api_management.apim_internal.resource_group_name
 } 