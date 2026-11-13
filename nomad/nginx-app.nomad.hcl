variable "image_tag" {
  type    = string
  default = "REPLACE_WITH_IMAGE_SHA"
}

job "nginx-app" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    shutdown_delay = "5s"
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name     = "nginx-app"
      port     = "http"
      provider = "consul"

      check {
        name     = "http-health"
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    restart {
      attempts = 3
      interval = "30m"
      delay    = "5s"
      mode     = "fail"
    }

    reschedule {
      attempts       = 3
      interval       = "1h"
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "5m"
      unlimited      = false
    }

    update {
      max_parallel      = 1
      min_healthy_time  = "10s"
      healthy_deadline  = "2m"
      auto_revert       = true
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/kjakeportacio/devops-intern-final:${var.image_tag}"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
