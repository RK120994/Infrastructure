# >>> Add the Patient Acuity api to platform internal apim
resource "azurerm_api_management_api" "api_impilo_patient_acuity_score" {
  name                  = "${var.stage}-impilo-patient-acuity-score"
  api_management_name   = var.apim_internal_name
  resource_group_name   = var.apim_resource_group_name
  display_name          = "${var.stage}-impilo-patient-acuity-score"
  description           = "This is Impilo Patient Acuity backend URL used to get acuity score"
  path                  = "${var.stage}-impilo-patient-acuity-score"
  service_url           = var.impilo_patient_acuity_score_url
  protocols             = ["https"]
  revision              = "1"
  subscription_required = false
}

# >>> Associate the api to the product (which is already created.)
resource "azurerm_api_management_product_api" "product_api_impilo_patient_acuity_score" {

  api_name            = azurerm_api_management_api.api_impilo_patient_acuity_score.name
  api_management_name = azurerm_api_management_api.api_impilo_patient_acuity_score.api_management_name
  resource_group_name = azurerm_api_management_api.api_impilo_patient_acuity_score.resource_group_name
  product_id          = var.apim_internal_product_id
}
# >>> Add policies at api level
resource "azurerm_api_management_api_policy" "policy_api_impilo_patient_acuity_score" {
  depends_on = [
    azurerm_api_management_named_value.named_value_azure_UKG_audience
  ]
  api_name            = azurerm_api_management_api.api_impilo_patient_acuity_score.name
  api_management_name = azurerm_api_management_api.api_impilo_patient_acuity_score.api_management_name
  resource_group_name = azurerm_api_management_api.api_impilo_patient_acuity_score.resource_group_name

  xml_content = <<XML
   <policies>
       <inbound>
           <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized by API M. Access token is missing or invalid.">
            <openid-config url="https://login.microsoftonline.com/${var.tenant_Id}/v2.0/.well-known/openid-configuration" />
            <required-claims>
                <claim name="aud">
                    <value>{{${local.named_value_UKG_audience}}}</value>
                </claim>
            </required-claims>
        </validate-jwt>
           </inbound>
           <backend>
               <base/>
           </backend>
           <outbound>
               <base/>
           </outbound>
           <on-error>
               <base/>
           </on-error>
       </policies>
  XML
}
# >>> Define the operation
resource "azurerm_api_management_api_operation" "api_operation_impilo_patient_acuity_score" {

  operation_id        = "api-impilo-patient-acuity-score"
  api_name            = azurerm_api_management_api.api_impilo_patient_acuity_score.name
  api_management_name = azurerm_api_management_api.api_impilo_patient_acuity_score.api_management_name
  resource_group_name = azurerm_api_management_api.api_impilo_patient_acuity_score.resource_group_name
  display_name        = "api-impilo-patient-acuity-score"
  method              = "POST"
  url_template        = "/advancedscheduler/api/acuity/acuityscores"
  description         = "Operation to get Patient Acuity Score"

  response {
    status_code = 200
  }
}
# >>> Add policies at operation level
resource "azurerm_api_management_api_operation_policy" "policy_api_operation_impilo_patient_acuity_score" {
  depends_on = [
    azurerm_api_management_named_value.named_value_authorization_token_patient_acuity,
    azurerm_api_management_api_operation.api_operation_impilo_patient_acuity_score
  ]

  api_name            = azurerm_api_management_api.api_impilo_patient_acuity_score.name
  api_management_name = azurerm_api_management_api.api_impilo_patient_acuity_score.api_management_name
  resource_group_name = azurerm_api_management_api.api_impilo_patient_acuity_score.resource_group_name
  operation_id        = azurerm_api_management_api_operation.api_operation_impilo_patient_acuity_score.operation_id

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-header name="Authorization" exists-action="override">
            <value>{{${local.named_value_impilo_token}}}</value>
        </set-header>
        <set-header name="content-type" exists-action="override">
					<value>application/json</value>
		</set-header>
    </inbound>
    <!-- Control if and how the requests are forwarded to services  -->
    <backend>
        <base />
    </backend>
    <!-- Customize the responses -->
    <outbound>
        <base />
    </outbound>
    <!-- Handle exceptions and customize error responses  -->
    <on-error>
        <base />
    </on-error>
</policies>
  XML
}
# Diagnostic settings for API
# resource "azurerm_api_management_api_diagnostic" "api_diagnostic_api_creditSafe_notification" {
#   identifier                = "applicationinsights"
#   resource_group_name       = var.platform_core_rg
#   api_management_name       = var.apim_internal_name
#   api_name                  = azurerm_api_management_api.api_creditSafe_notification.name
#   api_management_logger_id  = var.apim_logger_id
#   sampling_percentage       = 100.0
#   always_log_errors         = true
#   log_client_ip             = true
#   verbosity                 = "verbose"
#   http_correlation_protocol = "W3C"
# }
