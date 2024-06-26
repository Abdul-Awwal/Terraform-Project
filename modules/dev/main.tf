// dev/main.tf

provider "azurerm" {
  features {}
}

module "web_app" {
  source                = "../webapp"
  resource_group_name   = "dev-resources"
  location              = "East US"
  app_service_name      = "dev-appservice"
  app_service_tier      = "Standard"
  app_service_size      = "S1"
  sql_server_name       = "dev-sqlserver"
  sql_admin_username    = "adminuser"
  sql_admin_password    = "P@ssw0rd123"
  sql_database_name     = "dev-database"
  sql_sku_name          = "S0"
}
