terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {
  host = "ssh://netology@93.77.180.230"
  }

resource "random_password" "root_pass" {
  length           = 15
  special          = true
  override_special = "!#$%&*()_=+[]{}<>:?"
}
resource "random_password" "user_pass" {
  length           = 6
  special          = true
  override_special = "!#$%&*()_=+[]{}<>:?"
}
resource "random_password" "rnd_name" {
  length = 4
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.name
  name  = "ex2_${random_password.rnd_name.result}"
  restart = "always" 
  ports {
    internal = 3306
    external = 3306
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_pass.result}",
    "MYSQL_PASSWORD=${random_password.user_pass.result}",
    "MYSQL_DATABASE=test_db",
    "MYSQL_USER=app",
    "MYSQL_ROOT_HOST='%'"
    
  ]
}
