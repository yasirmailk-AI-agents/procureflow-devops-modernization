provider "docker" {}
resource "docker_image" "registry" { name = "registry:2" }
resource "docker_container" "registry" {
  name    = var.registry_name
  image   = docker_image.registry.image_id
  restart = "always"
  ports { internal = 5000; external = var.registry_port; ip = "127.0.0.1" }
}
