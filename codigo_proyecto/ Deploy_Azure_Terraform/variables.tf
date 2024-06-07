//google

variable "project" {
  description = "Este es el proyecto de Google"
  type        = string
}

variable "region" {
  description = "Esta es la región de Azure"
  type        = string
}

// Azure


variable "clientid" {
    description = "Client ID"
    type = string  
}

variable "clientsecret" {
    description = "Client Secret"
    type = string  
}

variable "subscriptionid" {
    description = "Subscription ID"
    type = string  
}

variable "tenantid" {
    description = "Tenant ID"
    type = string  
}

variable "location" {
    description = "Localización principal"
    type = string  
}

variable "rg_aks" {
    description = "Nombre del Resource Group de Kubernetes"
    type = string  
}

variable "rg_tm" {
    description = "Nombre del Resource Group de Kubernetes"
    type = string  
}

variable "rg_backup" {
    description = "Nombre del Resource Group de backup"
    type = string  
}

variable "location_backup" {
    description = "Localización del Resource Group de Backup"
    type = string  
}

variable "location_aks" {
    description = "Localización del Resource Group de AKS"
    type = string  
}

variable "cluster_aks_name" {
  description = "Nombre del cluster AKS"
  type = string
}


variable "tm" {
  description = "Nombre del perfil Traffic Manager"
  type = string
}

variable "sa_backup" {
  description = "Nombre del storage account de backup"
  type = string
}

variable "vault_name" {
  description = "Nombre del Backup Vault"
  type = string
}