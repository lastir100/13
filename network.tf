#создаем облачную сеть
resource "yandex_vpc_network" "netology" {
  name = "devops-coursework"
}

#создаем подсеть zone A
resource "yandex_vpc_subnet" "netology_a" {
  name           = "devops-coursework-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем подсеть zone B
resource "yandex_vpc_subnet" "netology_b" {
  name           = "devops-coursework-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "devops-coursework-gateway"
  shared_egress_gateway {}
}

#создаем сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt" {
  name       = "devops-coursework-route-table"
  network_id = yandex_vpc_network.netology.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

#создаем группы безопасности(firewall)

resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.netology.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "ssh" {
  name       = "ssh-sg"
  network_id = yandex_vpc_network.netology.id
  ingress {
    description    = "Allow SSH only from bastion"
    protocol       = "TCP"
    port           = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }
  
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.netology.id

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    security_group_id = yandex_vpc_security_group.alb.id
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    security_group_id = yandex_vpc_security_group.alb.id
  }
  ingress {
    description    = "Allow Prometheus 9100"
    protocol       = "TCP"
    port           = 9100
    security_group_id = yandex_vpc_security_group.prometheus.id
  }
  ingress {
    description    = "Allow Prometheus 9113"
    protocol       = "TCP"
    port           = 9113
    security_group_id = yandex_vpc_security_group.prometheus.id
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "alb" {
  name       = "alb-sg"
  network_id = yandex_vpc_network.netology.id

  ingress {
    description       = "Allow health checks from Yandex Cloud"
    protocol          = "TCP"
    port              = 30080
    predefined_target = "loadbalancer_healthchecks"
  }
  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "grafana" {
  name       = "grafana-sg"
  network_id = yandex_vpc_network.netology.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 3000
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "kibana" {
  name       = "kibana-sg"
  network_id = yandex_vpc_network.netology.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "prometheus" {
  name       = "prometheus-sg"
  network_id = yandex_vpc_network.netology.id
  ingress {
    description    = "Allow 10.0.0.0/8"
    protocol       = "TCP"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "elasticsearch" {
  name       = "elasticsearch-sg"
  network_id = yandex_vpc_network.netology.id
  ingress {
    description    = "Allow Kibana access"
    protocol       = "TCP"
    port           = 9200
    security_group_id = yandex_vpc_security_group.kibana.id
  }
  ingress {
    description    = "Allow Filebeat from web servers"
    protocol       = "TCP"
    port           = 9200
    security_group_id = yandex_vpc_security_group.web_sg.id
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}
