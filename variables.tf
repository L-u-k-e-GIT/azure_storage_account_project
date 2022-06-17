


variable "MD_DIAG_STORAGE_ACCOUNT" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
 
}


variable "MD_RG_NAME" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
}



variable "MD_PROJECT_NAME" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
}



variable "MD_DNS_privatelink_blob" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
}

variable "MD_SUBSCRIPTION_PREFIX" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
}

variable "MD_LOCATION" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
}

variable "MD_ST_PREFIX" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
}
 

 variable "MD_PE_PREFIX" {
  type        = string
  description = "Prefisso pre private endpoint"
  default     = ""
}

 variable "MD_REGION_PREFIX" {
  type        = string
  description = "Prefisso pre private endpoint"
  default     = ""
}


variable "MD_SUBNET_ID" {
  type        = string
  description = "ID della subnet"
  default     = ""
}


variable "MD_BCK_VAULT_PREFIX" {
  type        = string
  description = "ID della subnet"
  default     = ""
}


variable "MD_BCK_POLICY_ST_PREFIX" { 
 description = "Prefisso Backup Storage Account Policy"
 type = string
 default = ""
}