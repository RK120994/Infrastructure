resource "azurerm_api_management_product" "integration_apim_product" {
    product_id            = "${var.stage}-integration-apim-product"
    api_management_name   = data.azurerm_api_management.apim_internal.name
    resource_group_name   = data.azurerm_api_management.apim_internal.resource_group_name
    display_name          = "${var.stage}-integration-apim-product"
    description           = "Product created for Integration layer"
    subscription_required = true
    subscriptions_limit   = 0
    approval_required     = false
    published             = true
    terms                 = "These are the terms and conditions for this product."
  }
resource "azurerm_api_management_subscription" "integration_apim_product_subscription" {
    api_management_name   = data.azurerm_api_management.apim_internal.name
    resource_group_name   = data.azurerm_api_management.apim_internal.resource_group_name
    product_id            = azurerm_api_management_product.integration_apim_product.id
    display_name          = "apim-subscription-key-internal"
    state                 = "active"
    allow_tracing         = true
}