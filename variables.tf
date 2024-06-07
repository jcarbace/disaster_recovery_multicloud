//google

variable "project" {
  description = "Este es el proyecto"
  type        = string
}

variable "region" {
  description = "Esta es la región"
  type        = string
}

# variable "bucket_name" {
#   description = "nombre del bucket"
#   type        = string
# }

variable "bucket_location" {
  description = "value for bucket location"
  type        = string
}

variable "network_prefix" {
  description = "Prefijo de la red"
  type        = string
}

// Variables adicionales para el balanceador de carga

variable "target_tags" {
  description = "Etiquetas de destino para el balanceador de carga"
  type        = list(string)
  default     = []
}

variable "firewall_networks" {
  description = "Redes de firewall para el balanceador de carga"
  type        = list(string)
  default     = []
}

variable "backend_protocol" {
  description = "Protocolo del backend para el balanceador de carga"
  type        = string
  default     = "HTTP"
}

variable "backend_port" {
  description = "Puerto del backend para el balanceador de carga"
  type        = number
  default     = 80
}

variable "backend_port_name" {
  description = "Nombre del puerto del backend para el balanceador de carga"
  type        = string
  default     = "http"
}

variable "backend_timeout_sec" {
  description = "Tiempo de espera del backend para el balanceador de carga"
  type        = number
  default     = 10
}

variable "backend_enable_cdn" {
  description = "Habilitar CDN para el backend del balanceador de carga"
  type        = bool
  default     = false
}

variable "health_check_request_path" {
  description = "Ruta de solicitud de verificación de salud para el balanceador de carga"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Puerto de verificación de salud para el balanceador de carga"
  type        = number
  default     = 80
}

variable "log_config_enable" {
  description = "Habilitar la configuración de registro para el balanceador de carga"
  type        = bool
  default     = true
}

variable "log_config_sample_rate" {
  description = "Tasa de muestra de la configuración de registro para el balanceador de carga"
  type        = number
  default     = 1.0
}

variable "iap_config_enable" {
  description = "Habilitar la configuración de IAP para el balanceador de carga"
  type        = bool
  default     = false
}
variable "zone" {
  description = "Zona"
  type        = string

}
