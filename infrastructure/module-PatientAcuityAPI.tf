 module "Patient_Acuity_API" {
 	 source                                     = "./modules/PatientAcuityAPI"
    stage                                      = var.stage
    resource_group_name                        = var.resource_group_name
    apim_resource_group_name                   = data.azurerm_api_management.apim_internal.resource_group_name
    apim_internal_name                         = data.azurerm_api_management.apim_internal.name
    apim_internal_product_id                   = data.azurerm_api_management_product.integration_apim_internal_api_product.product_id
    impilo_patient_acuity_score_url            = var.impilo_patient_acuity_score_url
    impilo_patient_acuity_authorization_token  = var.impilo_patient_acuity_authorization_token
    UKG_audience_value                         = var.UKG_audience_value
    UKG_role_value                             = var.UKG_role_value
    tenant_Id                                  = var.tenant_Id
 }