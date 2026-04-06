variable "container_name" {
  description = "Nombre del contenedor web"
  type        = string
  default     = "web-lab26"
}

variable "host_port" {
  description = "Puerto del host"
  type        = number
  default     = 8080
}
