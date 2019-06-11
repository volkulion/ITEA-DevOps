terraform {
  backend "azurerm" {
    storage_account_name = "terraformv1"
    container_name       = "tera"
    key                  = "dev.terraform.tera"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "d44RgCHunIPF9HqWi3cOn0cqkOtEJbT5rN4sglVXSjVkKZPxSG7Rs9VL3hcu3hxE/2+xGJw7Oe6f+rC2B4oqXg=="
  }
}