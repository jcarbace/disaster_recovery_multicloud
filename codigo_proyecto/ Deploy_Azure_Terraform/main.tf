provider "google" {
  credentials = file("service_account.json")
  project     = var.project
  region      = var.region
}

terraform {
  backend "gcs" {
    bucket      = "capstonebucket-jd"
    prefix      = "terraform/state"
    credentials = "service_account.json"
  }
}

provider "azurerm" {
  features {
  }
  client_id                               = var.clientid
  client_secret                           = var.clientsecret
  tenant_id                               = var.tenantid
  subscription_id                         = var.subscriptionid
}










# AKS

resource "azurerm_resource_group" "rg_aks" {
  name                                    = var.rg_aks
  location                                = var.location_aks
}

resource "azurerm_kubernetes_cluster" "cluster_aks" {
  name                                    = var.cluster_aks_name
  location                                = var.location_aks
  resource_group_name                     = var.rg_aks
  dns_prefix                              = "capstoneg4"
  depends_on                              = [ azurerm_resource_group.rg_aks  ]

  default_node_pool {
    name                                  = "agentpool"
    node_count                            = 2
    vm_size                               = "Standard_DS2_v2"
    enable_auto_scaling                   = true
    min_count                             = 2
    max_count                             = 5
    os_sku                                = "Ubuntu"
    type                                  = "VirtualMachineScaleSets"
    }

  identity {
    type                                  = "SystemAssigned"
  }
  
  network_profile {
    network_plugin                        = "azure"
    network_policy                        = "calico"
    load_balancer_sku                     = "standard"
    ip_versions                           = ["IPv4"]
    service_cidr                          = "10.0.96.0/20"
    dns_service_ip                        = "10.0.96.250"
  }
}

output "cluster_aks" {
  value                                   = [azurerm_kubernetes_cluster.cluster_aks.id,
                                            azurerm_kubernetes_cluster.cluster_aks.name]
}














# TRAFFIC MANAGER

resource "azurerm_resource_group" "rg_tm" {
  name                                    = var.rg_tm
  location                                = "West US"
}

resource "azurerm_traffic_manager_profile" "tm" {
  name                                    = var.tm
  resource_group_name                     = azurerm_resource_group.rg_tm.name
  traffic_routing_method                  = "Priority"
  depends_on                              = [azurerm_resource_group.rg_tm]

  dns_config {
    relative_name                         = "trafficmancapstone"
    ttl                                   = 100
  }

  monitor_config {
    protocol                              = "HTTP"
    port                                  = 80
    path                                  = "/"
    interval_in_seconds                   = 30
    timeout_in_seconds                    = 9
    tolerated_number_of_failures          = 3
  }
}

resource "azurerm_traffic_manager_external_endpoint" "gcp_endpoint" {
  name                                    = "gcpcapstoneendpoint"
  profile_id                              = azurerm_traffic_manager_profile.tm.id
  weight                                  = 5
  target                                  = "35.209.88.253"
  priority                                = 2
  depends_on                              = [azurerm_traffic_manager_profile.tm]
}