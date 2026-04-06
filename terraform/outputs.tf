output "container_name" {
  description = "Nombre del contenedor creado"
  value       = docker_container.web.name
}

output "container_id" {
  description = "ID del contenedor creado"
  value       = docker_container.web.id
}
