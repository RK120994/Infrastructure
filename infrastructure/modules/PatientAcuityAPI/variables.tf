#naming
variable "stage" {
	type = string
	description = "The Stage"
}
variable "apim_internal_name" {
	type = string
	description = "The APIM instance name"
}
variable "resource_group_name" {
	type = string
	description = "The Resource Group name"
}
variable "apim_resource_group_name" {
	type = string
	description = "The APIM Resource Group name"
}
variable "impilo_patient_acuity_score_url" {
	type = string
	description = "The Patient Acuity Score URL"
}
variable "impilo_patient_acuity_authorization_token" {
	type = string
	description = "ThePatient Acuity Score authorization token"
}
variable "apim_internal_product_id" {
	type = string
	description = "The APIM Internal Product Id"
}
variable "UKG_audience_value" {
      type = string
	description = "UKG Audience Value after App Registration in Microsoft Entra ID"
}
variable "UKG_role_value" {
      type = string
	description = "UKG Role Value after App Registration in Microsoft Entra ID"
}
variable "tenant_Id" {
      type = string
	description = "Tenanat ID of Azure Integration project"
}