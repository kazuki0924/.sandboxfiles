output "resource_group_id" {
  value = azurerm_resource_group.sandbox-rg.id
}

output "tls_private_key" {
  value     = tls_private_key.sandbox_ssh.private_key_pem
  sensitive = true
}
