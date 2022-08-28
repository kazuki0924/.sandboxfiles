variable "vm_resource_group_name" {
  default = "azure-vm-sandbox-rg"
}

variable "acr_resource_group_name" {
  default = "acr-sandbox-rg"
}

variable "location" {
  default = "japanwest"
}

variable "environment" {
  default = "dev"
}

variable "project" {
  default = "sandbox"
}

variable "subscription_id" {
  type = string
}

variable "sp_client_id" {
  type = string
}
variable "sp_client_secret" {
  type = string
}

variable "sp_client_tenant_id" {
  type = string
}
