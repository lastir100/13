
resource "local_file" "inventory" {
  content  = <<-XYZ
  [bastion]
  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}


  [webservers]
  ${yandex_compute_instance.web_a.network_interface.0.ip_address}
  ${yandex_compute_instance.web_b.network_interface.0.ip_address}
 
  [prometheus]
  ${yandex_compute_instance.prometheus.network_interface.0.ip_address}
  
  [grafana]
  ${yandex_compute_instance.grafana.network_interface.0.ip_address}
  
  [elasticsearch]
  ${yandex_compute_instance.elasticsearch.network_interface.0.ip_address}

  [kibana]
  ${yandex_compute_instance.kibana.network_interface.0.ip_address}
  XYZ
  filename = "./hosts.ini"
}

resource "local_file" "ssh_config" {
  content  = <<-XYZ
  Host ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}  #адрес вашего бастиона
    User user

  Host 10.0.*
    ProxyJump ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
    User user


  XYZ
  filename = "${path.module}/ssh_config"
  # не забыть скопировать (cat ssh_config >> ~/.ssh/config).
}


