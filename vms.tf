
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}


#создаем ВМ
resource "yandex_compute_instance" "bastion" {
  name        = "bastion" #Имя ВМ в облачной консоли
  hostname    = "bastion" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }
}


resource "yandex_compute_instance" "web_a" {
  name        = "web-a" #Имя ВМ в облачной консоли
  hostname    = "web-a" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web_sg.id, yandex_vpc_security_group.ssh.id]
  }
}

resource "yandex_compute_instance" "web_b" {
  name        = "web-b" #Имя ВМ в облачной консоли
  hostname    = "web-b" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web_sg.id, yandex_vpc_security_group.ssh.id]

  }
}

resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus" #Имя ВМ в облачной консоли
  hostname    = "prometheus" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.prometheus.id, yandex_vpc_security_group.ssh.id]
  }
}

resource "yandex_compute_instance" "grafana" {
  name        = "grafana" #Имя ВМ в облачной консоли
  hostname    = "grafana" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.grafana.id, yandex_vpc_security_group.ssh.id]
  }
}


resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch" #Имя ВМ в облачной консоли
  hostname    = "elasticsearch" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 30
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.elasticsearch.id, yandex_vpc_security_group.ssh.id]

  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana" #Имя ВМ в облачной консоли
  hostname    = "kibana" #формирует FDQN имя хоста, без hostname будет сгенерировано случайное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jreb12k82ivskg7pr"
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology_b.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana.id, yandex_vpc_security_group.ssh.id]

  }
}

# Создание snapshot schedule (расписание создания снимков)
resource "yandex_compute_snapshot_schedule" "daily_backup" {
  name = "daily-backup-schedule"
  description = "Ежедневные снапшоты всех ВМ, хранятся 7 дней"


  schedule_policy {
    expression = "0 3 * * *" # каждый день в 03:00 UTC
  }


  retention_period = "168h" # 7 дней (7 * 24 часа)


  snapshot_count = 7 # максимум 7 снимков на диск (опционально)


  snapshot_spec {
    description = "Daily snapshot by Terraform"
    labels = {
      created_by = "terraform"
      type = "daily"
    }
  }


  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web_a.boot_disk[0].disk_id,
    yandex_compute_instance.web_b.boot_disk[0].disk_id,
    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
    yandex_compute_instance.grafana.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id
  ]
}