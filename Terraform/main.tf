#config file for Azure components

provider "azurerm" {
  features {}
}

#resource group for our azure components
resource "azurerm_resource_group" "demo" {
  name     = "demo-resources"
  location = "West Europe"
}

#this defines plan for our host machine
resource "azurerm_app_service_plan" "demoappserviceplan" {
  name                = "demo-app-service-plan"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

#Azure app service
resource "azurerm_app_service" "demoappservice" {
  name                = "demo-app-service"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  app_service_plan_id = azurerm_app_service_plan.demo.id
}

#this defines our db server
resource "azurerm_sql_server" "mydbsqlserver" {
  name                         = "mydb-sql-server"
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = azurerm_resource_group.demo.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password123"
}

#this defines our database 
resource "azurerm_sql_database" "mydb" {
  name                = "mydb"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  server_name         = azurerm_sql_server.mydbsqlserver.name
  edition             = "Basic"
}

#this resource is for autoscaling our resources
resource "azurerm_monitor_autoscale_setting" "autoscaledemo" {
  name                = "autoscale-demo"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  target_resource_id  = azurerm_app_service_plan.demoappserviceplan.id

  profile {
    name = "defaultProfile"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service.demoappservice.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 75
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service.demoappservice.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 25
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }
}

#this defines the group of security rules
resource "azurerm_network_security_group" "demosecuritygroup" {
  name                = "demo-security-group"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

#this rule is for the incoming traffic to our API
resource "azurerm_network_security_rule" "inboundsecurityrule" {
  name                        = "inbound-security-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demo.name
  network_security_group_name = azurerm_network_security_group.demosecuritygroup.name
}

#this rule id for the outgoing traffic from our API
resource "azurerm_network_security_rule" "outbound_security_rule" {
  name                        = "outbound-security-rule"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demo.name
  network_security_group_name = azurerm_network_security_group.demosecuritygroup.name
}
