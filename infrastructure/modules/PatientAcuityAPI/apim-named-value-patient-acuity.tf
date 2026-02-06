resource "azurerm_api_management_named_value" "named_value_authorization_token_patient_acuity"{
  name                 = local.named_value_impilo_token
  resource_group_name  = var.apim_resource_group_name
  api_management_name  = var.apim_internal_name
  display_name         = local.named_value_impilo_token
  secret               = true
  value                = var.impilo_patient_acuity_authorization_token
}
resource "azurerm_api_management_named_value" "named_value_azure_UKG_audience"{
  name                 = local.named_value_UKG_audience
  resource_group_name  = var.apim_resource_group_name
  api_management_name  = var.apim_internal_name
  display_name         = local.named_value_UKG_audience
  secret               = true
  value                = var.UKG_audience_value
}
resource "azurerm_api_management_named_value" "named_value_azure_UKG_role"{
  name                 = local.named_value_UKG_role
  resource_group_name  = var.apim_resource_group_name
  api_management_name  = var.apim_internal_name
  display_name         = local.named_value_UKG_role
  secret               = true
  value                = var.UKG_role_value
}