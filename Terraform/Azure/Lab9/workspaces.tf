terraform {
  backend "azurerm" {
    storage_account_name = "terraformv1"
    container_name       = "tera"
    key                  = "dev.terraform.tera"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "QYOWIiLKPVBan1n5YKuZKgawNffom4//NhW1qAZzigVNi4UyONfKryast1B0y1PEzKlJ5sEfc66LUsTJx0Iq7Q=="
  }
}