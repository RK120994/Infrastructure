output "resource_group_name" {
  value ={
    resource_group_name                        = var.resource_group_name
    apim_resource_group_name                   = data.azurerm_api_management.apim_internal.resource_group_name
  }                       
}