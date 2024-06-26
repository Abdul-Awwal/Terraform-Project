terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "webapp" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "webapp" {
  name                = "${var.app_service_name}-plan"
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  sku {
    tier = var.app_service_tier
    size = var.app_service_size
  }
}

resource "azurerm_app_service" "webapp" {
  name                = var.app_service_name
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  app_service_plan_id = azurerm_app_service_plan.webapp.id

  site_config {
    scm_type = "LocalGit"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.webapp.name
  location                     = azurerm_resource_group.webapp.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_sql_database" "sqldb" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.webapp.name
  location            = azurerm_resource_group.webapp.location
  server_name         = azurerm_sql_server.sqlserver.name
  sku {
    name     = var.sql_sku_name
    tier     = var.sql_tier
    capacity = var.sql_capacity
  }
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.app_service_name}-appinsights"
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  application_type    = "web"
}
