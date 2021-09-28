output "resource_group_id" {
  value = azurerm_resource_group.azure-vm-sandbox-rg.id
}

output "acr_login_server" {
  value = azurerm_container_registry.sandbox-acr.login_server
}

output "tls_private_key" {
  value     = tls_private_key.azure-vm-sandbox-ssh.private_key_pem
  sensitive = true
}
