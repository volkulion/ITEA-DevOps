
output "publicIp" {
  value = "${azurerm_public_ip.publicIp.ip_address}"
  description = "The public IP address of the main server instance."
}
