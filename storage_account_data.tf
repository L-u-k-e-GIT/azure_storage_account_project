##  Storage account for project ##########
resource "azurerm_storage_account" "st_data" {
   
    name                        = "${var.MD_ST_PREFIX}${var.MD_PROJECT_NAME}${var.MD_SUBSCRIPTION_PREFIX}01" 
    resource_group_name         = var.MD_RG_NAME
    location                    = var.MD_LOCATION
    account_tier                = "Standard"
    account_replication_type    = "ZRS"
    access_tier                 = "Cool"
    is_hns_enabled              = true
    min_tls_version             = "TLS1_2"
    allow_nested_items_to_be_public  = false
    network_rules {
             bypass = ["AzureServices"] #to be one of [AzureServices Logging Metrics None]
             default_action   = "Deny"
        }
    blob_properties  {
      delete_retention_policy { days = 14 }
      container_delete_retention_policy { days = 14 }
    }
    lifecycle {
    ignore_changes = [
     tags
    ]
  }
}




#PRIVATE ENDPOINT FOR THE STORAGE ACCOUNT IN THE SAME SUBNET OF THE PROJECT




resource "azurerm_private_endpoint" "pe_st" {
  
  name                = "${var.MD_PE_PREFIX}-${var.MD_PROJECT_NAME}-${var.MD_SUBSCRIPTION_PREFIX}-${var.MD_REGION_PREFIX}-01" 
  location            = var.MD_LOCATION
  resource_group_name = var.MD_RG_NAME
  subnet_id           = var.MD_SUBNET_ID

  private_dns_zone_group {
    name                 = "privatelink.blob.core.windows.net"
    private_dns_zone_ids = [var.MD_DNS_privatelink_blob]
  }

  private_service_connection {
    name                              = "${var.MD_PE_PREFIX}-${var.MD_PROJECT_NAME}-${var.MD_SUBSCRIPTION_PREFIX}-${var.MD_REGION_PREFIX}-01-connection"
    private_connection_resource_id = azurerm_storage_account.st_data.id
    is_manual_connection              = false
    subresource_names = ["blob"]
  }
  lifecycle {
    ignore_changes = [
     tags
    ]
  }
}



#CONTAINER CREATION IN THE SAME STORAGE ACCOUNT
/*
resource "azurerm_storage_container" "st_container" {
  name                  = var.MD_PROJECT_NAME
  storage_account_name  = azurerm_storage_account.st_data.name
  container_access_type = "private"
  #depends_on = [azurerm_storage_account_network_rules.st_rule]
}*/

/*
resource "azurerm_storage_account_network_rules" "st_rule" {
  storage_account_id = azurerm_storage_account.st_data.id

  default_action             = "Deny"
  /*virtual_network_subnet_ids = [var.MD_SUBNET_ID]
  bypass                     = ["Metrics","AzureServices", "Logging"]
  depends_on = [azurerm_storage_container.st_container]
}*/



/*
#BACKUP VAULT CREATION FOR STORAGE ACCOUNT BACKUP

resource "azurerm_data_protection_backup_vault" "st_back" {
  name                = "${var.MD_BCK_VAULT_PREFIX}-${var.MD_PROJECT_NAME}-${var.MD_SUBSCRIPTION_PREFIX}-${var.MD_REGION_PREFIX}" 
  resource_group_name = var.MD_RG_NAME
  location            = var.MD_LOCATION
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  identity {
    type = "SystemAssigned"
  }
}

#ASSIGN BACKUP ROLE FOR STORAGE ACCOUNT TO BACKUP VAULT

resource "azurerm_role_assignment" "st_bck_role" {
  scope                = azurerm_storage_account.st_data.id
  role_definition_name = "Storage Account Backup Contributor Role"
  principal_id         = azurerm_data_protection_backup_vault.st_back.identity[0].principal_id
  
}

#POLICY BACKUP X SA
resource "azurerm_data_protection_backup_policy_blob_storage" "st_bck_policy" {
  name               = "${var.MD_BCK_POLICY_ST_PREFIX}-${var.MD_PROJECT_NAME}-${var.MD_SUBSCRIPTION_PREFIX}-${var.MD_REGION_PREFIX}" 
  vault_id           = azurerm_data_protection_backup_vault.st_back.id
  retention_duration = "P30D"
}

/*

######### ASSIGN BACKUP POLICY ###############
resource "azurerm_data_protection_backup_instance_blob_storage" "assign_bck" {
  #bckpol-st-iplanet-apps-azfk
  name               = "${var.MD_BCK_POLICY_ST_PREFIX}-${var.MD_PROJECT_NAME}-${var.MD_SUBSCRIPTION_PREFIX}-${var.MD_REGION_PREFIX}" 
  #name               = "example-backup-instance"
  vault_id           = azurerm_data_protection_backup_vault.st_back.id
  location           = var.MD_LOCATION
  storage_account_id = azurerm_storage_account.st_data.id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.st_bck_policy.id
  depends_on = [azurerm_role_assignment.st_bck_role, time_sleep.wait_300_seconds]
}*/

/*
resource "null_resource" "previous" {}
resource "time_sleep" "wait_300_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "300s"
}*/