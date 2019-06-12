terraform {
  backend "azurerm" {
    storage_account_name = "terraformvolkulion"
    container_name       = "terraformvolkulion"
    key                  = "dev.terraform.tera"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "ge77klIZV/8JqzfESiJ1keTrllGESChAuaeigUwgJ0FhfYM7lnqZycvw7a6BzI7NlAbJguOJGssXnUanyjLxBg=="
  }
}
