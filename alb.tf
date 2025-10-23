#создаем ресурсы для Application load balancer


resource "yandex_alb_target_group" "devops_coursework_tg" {
  name = "devops-coursework-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.netology_a.id
    ip_address = yandex_compute_instance.web_a.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.netology_b.id
    ip_address = yandex_compute_instance.web_b.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "devops_coursework_bg" {
  name = "devops-coursework-backend-group"

  http_backend {
    name             = "devops-coursework-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.devops_coursework_tg.id]
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "devops_coursework_router" {
  name = "devops-coursework-http-router"

}

resource "yandex_alb_virtual_host" "devops_coursework_vhost" {
  name           = "devops-coursework-virtual-host"
  http_router_id = yandex_alb_http_router.devops_coursework_router.id
  route {
    name = "http-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.devops_coursework_bg.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "devops_coursework_alb" {
  name = "devops-coursework-load-balancer"

  network_id = yandex_vpc_network.netology.id

  security_group_ids = [yandex_vpc_security_group.alb.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.netology_a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.netology_b.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.devops_coursework_router.id
      }
    }
  }
}

