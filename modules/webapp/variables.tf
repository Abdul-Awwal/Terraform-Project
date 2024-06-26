variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "app_service_name" {
  description = "The name of the App Service"
  type        = string
}

variable "app_service_tier" {
  description = "The tier of the App Service Plan"
  type        = string
}

variable "app_service_size" {
  description = "The size of the App Service Plan"
  type        = string
}

variable "sql_server_name" {
  description = "The name of the SQL Server"
  type        = string
}

variable "sql_admin_username" {
  description = "The admin username for the SQL Server"
  type        = string
}

variable "sql_admin_password" {
  description = "The admin password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_database_name" {
  description = "The name of the SQL Database"
  type        = string
}

variable "sql_sku_name" {
  description = "The SKU name of the SQL Database"
  type        = string
}
