#naming
variable "stage" {
	type = string
	default ="AzureDev"
	description = "The Stage"
}
variable "location" {
	type = string
	description = "The location name"
}
variable "resource_group_name" {
    type = string
	description = "The resource group name"
}
variable "apim_resource_group_name" {
    type = string
	description = "APIM Instance resource group name"
}
variable "apim_instance_name" {
    type = string
	description = "APIM Instance name"
}
variable "service_bus_namespace_name" {
    type = string
	description = "Name of servcie bus instance namespace"
}
variable "service_bus_queue_Vision_BusinessStructure" {
    type = string
	description = "Name of servcie bus queue used for Vision Business Structure"
}
variable "service_bus_queue_Vision_EmployeeDataImport" {
    type = string
	description = "Name of servcie bus queue used for Vision EmployeeDataImport"
}
variable "service_bus_queue_UKGPro_NursingRequisitions_EDW" {
    type = string
	description = "Name of servcie bus queue UKGPro NursingRequisitions EDW"
}
variable "service_bus_queue_UKGPro_NursingRequisitions_NursingUtilities" {
    type = string
	description = "Name of servcie bus queue UKGPro NursingRequisitions NursingUtilities"
}
variable "service_bus_topic_UKGPro_NursingRequisitions" {
    type = string
	description = "Name of servcie bus topic UKGPro NursingRequisitions"
}
variable "impilo_patient_acuity_score_url"{
    type = string
	description = "Patient Acuity Score URL"
}
variable "impilo_patient_acuity_authorization_token" {
      type = string
	description = "Patient Acuity Score authorization token"
}
variable "UKG_audience_value" {
      type = string
	description = "UKG Audience Value after App Registration in Microsoft Entra ID"
}
variable "UKG_role_value" {
      type = string
	description = "UKG Role Value after App Registration in Microsoft Entra ID"
}
variable "UKG_audience_scope" {
      type = string
	description = "UKG Audience Scope after App Registration in Microsoft Entra ID"
}
variable "UKG_client_id" {
      type = string
	description = "UKG Client ID Value after App Registration in Microsoft Entra ID"
}
variable "UKG_client_secret" {
      type = string
	description = "UKG Client Secrete Value after App Registration in Microsoft Entra ID"
}
variable "tenant_Id" {
      type = string
	description = "Tenanat ID of Azure Integration project"
}
variable "apim_public_ip_address_id" {
      type = string
	description = "Public IP address assigned to APIM"
}
variable "apim_subnet_id" {
      type = string
	description = "Subnet ID assigned to APIM"
}
variable "apim_notification_sender_email" {
      type = string
	description = "Notification Email id in APIM Instance"
}
variable "apim_publisher_email" {
      type = string
	description = "Publisher Email id in APIM Instance"
}
variable "apim_sku_name" {
      type = string
	description = "SKU of APIM Instance"
}
variable "apim_virtual_network_type" {
      type = string
	description = "Virtual Network Type of APIM Instance"
}
variable "apim_public_network_access_enabled" {
      type = string
	description = "Public Access Enablement of APIM Instance"
}
variable "apim_host_name" {
      type = string
	description = " APIM Instance Host Name"
}
variable "tags_stage_mapping" {
  description = "Common tags for resources"
  type        = map(object({
    application : string
    BusinessUnit : string
    Owner : string
  }))
  default = {
    "AzureDev" :{
      application   = "AZURE INTEGRATION SERVICES"
      BusinessUnit  = "IT"
      Owner         = "Herculaas Cronje"
    },
    "AzureProd" : {
      application   = "TBC"
      BusinessUnit  = "TBC"
      Owner         = "TBC"
    }
  }
}