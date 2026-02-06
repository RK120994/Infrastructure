resource "azurerm_servicebus_namespace" "sb" {
  name                          = var.service_bus_namespace_name # Must be globally unique
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Premium"
  premium_messaging_partitions  = 1
  capacity                      = 1
  public_network_access_enabled = false
  tags                          = lookup (var.tags_stage_mapping,var.stage)
}
# Queues
resource "azurerm_servicebus_queue" "Vision_BusinessStructure_queue" {
  name                                 = var.service_bus_queue_Vision_BusinessStructure
  namespace_id                         = azurerm_servicebus_namespace.sb.id
  max_delivery_count                   = 3
  dead_lettering_on_message_expiration = true
  default_message_ttl                  = "PT4M"
 // max_message_size_in_kilobytes = 1024
}
resource "azurerm_servicebus_queue" "Vision_EmployeeDataImport_queue" {
  name                                 = var.service_bus_queue_Vision_EmployeeDataImport
  namespace_id                         = azurerm_servicebus_namespace.sb.id
  max_delivery_count                   = 3
  dead_lettering_on_message_expiration = true
  # default_message_ttl = "P1D"
  # max_message_size_in_kilobytes = 1024
}
resource "azurerm_servicebus_queue" "EDW_queue" {
  name                                 = var.service_bus_queue_UKGPro_NursingRequisitions_EDW
  namespace_id                         = azurerm_servicebus_namespace.sb.id
  max_delivery_count                   = 3
  dead_lettering_on_message_expiration = true
}
resource "azurerm_servicebus_queue" "NursingUtilities_queue" {
  name                                 = var.service_bus_queue_UKGPro_NursingRequisitions_NursingUtilities
  namespace_id                         = azurerm_servicebus_namespace.sb.id
  max_delivery_count                   = 3
  dead_lettering_on_message_expiration = true
}
# Topic
resource "azurerm_servicebus_topic" "NursingRequisitions_topic" {
  name         = var.service_bus_topic_UKGPro_NursingRequisitions
  namespace_id = azurerm_servicebus_namespace.sb.id
}
# SAS policies
resource "azurerm_servicebus_queue_authorization_rule" "ukgpro_businessstructure_listen" {
  name                = "UKGPro_ListenPolicy"
#namespace_id         = azurerm_servicebus_namespace.sb.id
  queue_id            = azurerm_servicebus_queue.Vision_BusinessStructure_queue.id

  listen = true
  send   = false
  manage = false
}
resource "azurerm_servicebus_queue_authorization_rule" "vision_businessstructure_send" {
  name                = "Vision_SendPolicy"
#namespace_id         = azurerm_servicebus_namespace.sb.id
  queue_id            = azurerm_servicebus_queue.Vision_BusinessStructure_queue.id

  listen = false
  send   = true
  manage = false
}
resource "azurerm_servicebus_queue_authorization_rule" "ukgpro_employeedata_listen" {
  name                = "UKGPro_ListenPolicy"
#namespace_id         = azurerm_servicebus_namespace.sb.id
  queue_id            = azurerm_servicebus_queue.Vision_EmployeeDataImport_queue.id

  listen = true
  send   = false
  manage = false
}
resource "azurerm_servicebus_queue_authorization_rule" "vision_employeedata_send" {
  name                = "Vision_SendPolicy"
#namespace_id         = azurerm_servicebus_namespace.sb.id
  queue_id            = azurerm_servicebus_queue.Vision_EmployeeDataImport_queue.id

  listen = false
  send   = true
  manage = false
}
#Azure Monitor
resource "azurerm_monitor_metric_alert" "dazusb01_deadletter_alert" {
  name                = "dazusb01-deadletter-alert"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_servicebus_namespace.sb.id]
  description         = "Alert when dead-lettered messages > 0"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.ServiceBus/namespaces"
    metric_name      = "DeadLetteredMessages"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name           = "EntityName"
      operator       = "Include"
      values         = ["Vision.BusinessStructure","Vision.EmployeeDataImport","ukgpro.nursingrequisitions.edw","ukgpro.nursingrequisitions.nursingutilities"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.integration_alert_group.id
  }
  
  tags              = lookup (var.tags_stage_mapping,var.stage)
}
resource "azurerm_monitor_action_group" "integration_alert_group" {
  name                = "integrations-deadletter-action-group"
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = "dlqalert"

  email_receiver {
    name          = "herculaas-alert"
    email_address = "herculaas.cronje@lifehealthcare.co.za"
  }
  email_receiver {
    name          = "silpa-alert"
    email_address = "silpa.chava@lifehealthcare.co.za"
  }
  email_receiver {
    name          = "yashpal-alert"
    email_address = "yashpal.bhosale@lifehealthcare.co.za"
  }

  tags            = lookup (var.tags_stage_mapping,var.stage)
}
# Private Endpoint linking to existing subnet
# resource "azurerm_private_endpoint" "dev-pe-dazusb01" {
#  name                = "dev-pe-dazusb01"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  subnet_id           = "/subscriptions/b75139bf-d609-4acd-9733-6123f7a270d4/resourceGroups/RG-ZA-DEV-CORE-NETWORK/providers/Microsoft.Network/virtualNetworks/dev-vnet-integrations/subnets/dev-snet-integrations"

#  private_service_connection {
#    name                           = "sb-connection"
#    private_connection_resource_id = azurerm_servicebus_namespace.sb.id
#    is_manual_connection           = false
#    subresource_names              = ["namespace"]
#  }
#}

##################################### Optional Private DNS Zone setup ##################
# resource "azurerm_private_dns_zone" "sb_dns" {
#   name                = "privatelink.servicebus.windows.net"
#   resource_group_name = data.azurerm_resource_group.rg.name
# }
#
# resource "azurerm_private_dns_zone_virtual_network_link" "sb_dns_link" {
#   name                  = "sb-dns-link"
#   resource_group_name   = data.azurerm_resource_group.rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.sb_dns.name
#   virtual_network_id    = "/subscriptions/b75139bf-d609-4acd-9733-6123f7a270d4/resourceGroups/RG-ZA-DEV-CORE-NETWORK/providers/Microsoft.Network/virtualNetworks/dev-vnet-integrations"
# }