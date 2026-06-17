packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nginx" {
  image  = "nginx:alpine"
  commit = true
}

build {
  name    = "custom-nginx-build"
  sources = ["source.docker.nginx"]

  # Copie du fichier index.html local vers le dossier web par défaut de Nginx
  provisioner "file" {
    source      = "index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "my-nginx-custom"
    tags       = ["v1"]
  }
}
