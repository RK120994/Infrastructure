#Create APIM Instance in Integration Resource Group
resource "azurerm_api_management" "internal_apim_integration" {
  name                            = var.apim_instance_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  publisher_name                  = "Life Healthcare"
  publisher_email                 = var.apim_publisher_email
  sku_name                        = var.apim_sku_name
  public_ip_address_id            = var.apim_public_ip_address_id
  public_network_access_enabled   = var.apim_public_network_access_enabled
  virtual_network_type            = var.apim_virtual_network_type
  virtual_network_configuration {
    subnet_id                     = var.apim_subnet_id
  }
 identity {
    identity_ids                  = []
    type                          = "SystemAssigned"
  }
  client_certificate_enabled      = false
  protocols {
    enable_http2                  = false
  #  http2_enabled                 = false
  }
  security {
   # backend_ssl30_enabled                               = false
   # backend_tls10_enabled                               = false
   # backend_tls11_enabled                               = false
    enable_backend_ssl30                                = false
    enable_backend_tls10                                = false
    enable_backend_tls11                                = false
    enable_frontend_ssl30                               = false
    enable_frontend_tls10                               = false
    enable_frontend_tls11                               = false
   # frontend_ssl30_enabled                              = false
   # frontend_tls10_enabled                              = false
   # frontend_tls11_enabled                              = false
    tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = false
    tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = false
    tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = false
    tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = false
    tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = false
    tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = false
    tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = false
    tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = false
    tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = false
    tls_rsa_with_aes256_gcm_sha384_ciphers_enabled      = false
    triple_des_ciphers_enabled                          = false
  }
  gateway_disabled                    = false  
  #min_api_version                     = ""
  notification_sender_email           = var.apim_notification_sender_email  
  tags                                = lookup (var.tags_stage_mapping,var.stage)
  zones                               = []
  
  dynamic "delegation" {
    for_each = local.delegation_enabled ? [1] : []
    content {
        subscriptions_enabled             = false
        #url                               = ""
        user_registration_enabled         = false
        #validation_key                    = "" # Masked sensitive attribute
    }
  }
  hostname_configuration {
    proxy {
      #certificate                     = "" # Masked sensitive attribute
      #certificate_password            = "" # Masked sensitive attribute
      default_ssl_binding             = true
      host_name                       = var.apim_host_name
    #  key_vault_certificate_id        = ""
    #  key_vault_id                    = ""
      negotiate_client_certificate    = false
    #  ssl_keyvault_identity_client_id = ""
    }
  }
  dynamic "sign_in" {
    for_each = local.sign_in_enabled ? [1] : []
    content {
        enabled             = false
        }
  } 
  
  dynamic "sign_up" {
    for_each = local.sign_up_enabled ? [1] : []
    content {
        enabled                         = true
        terms_of_service {
        consent_required                = false
        enabled                         = false
        text                            = "Sign up enabled text"
        }
    }
  }

}

#
#
#resource "azurerm_key_vault_access_policy" "kv_int_apim_policy" {
#  key_vault_id = data.azurerm_key_vault.kv_setup.id
#  tenant_id    = data.azurerm_client_config.current.tenant_id
#  object_id    = length(azurerm_api_management.internal.identity) == 1 ? azurerm_api_management.internal.identity[0].principal_id : null
#
#  secret_permissions = [
#    "get",
#    "list"
#  ]
#
#  certificate_permissions = [
#    "get",
#    "list"
#  ]
#
#  depends_on = [azurerm_api_management.internal]
#}
#
#resource "azurerm_api_management_custom_domain" "apim-dns-internal" {
#  api_management_id = azurerm_api_management.internal.id
#
#  proxy {
#    host_name                    = var.apim_gw_dns_url
#    key_vault_id                 = var.apim_dns_kv_certificate_id
#    default_ssl_binding          = true
#    negotiate_client_certificate = var.negotiate_client_cert
#  }
#}
#
#resource "azurerm_monitor_autoscale_setting" "internal-apim-autoscale" {
#  count               = var.make_autoscale ? 1 : 0
#  name                = "apim-${var.prefix}-${var.internal_apim_name}-${var.suffix}-autoscale"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  target_resource_id  = azurerm_api_management.internal.id
#
#  profile {
#    name = "defaultProfile"
#
#    capacity {
#      default = 1
#      minimum = 1
#      maximum = 5
#    }
#
#    rule {
#      metric_trigger {
#        metric_name        = "Capacity"
#        metric_resource_id = azurerm_api_management.internal.id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT30M"
#        time_aggregation   = "Average"
#        operator           = "GreaterThan"
#        threshold          = 80
#        metric_namespace   = "microsoft.apimanagement/service"
#      }
#
#      scale_action {
#        direction = "Increase"
#        type      = "ChangeCount"
#        value     = "1"
#        cooldown  = "PT1H"
#      }
#    }
#
#    rule {
#      metric_trigger {
#        metric_name        = "Capacity"
#        metric_resource_id = azurerm_api_management.internal.id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT30M"
#        time_aggregation   = "Average"
#        operator           = "LessThan"
#        threshold          = 35
#        metric_namespace   = "microsoft.apimanagement/service"
#      }
#
#      scale_action {
#        direction = "Decrease"
#        type      = "ChangeCount"
#        value     = "1"
#        cooldown  = "PT1H30M"
#      }
#    }
#  }
#}
 