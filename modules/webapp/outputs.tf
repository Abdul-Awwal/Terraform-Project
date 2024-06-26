output "app_service_default_site_hostname" {
  value = azurerm_app_service.webapp.default_site_hostname
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.sqlserver.fully_qualified_domain_name
}

output "sql_database_id" {
  value = azurerm_sql_database.sqldb.id
}

output "app_insights_instrumentation_key" {
  value = azurerm_application_insights.appinsights.instrumentation_key
}
