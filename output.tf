
# output "alb_public_ip" {
#   description = "The public IP address of the Application Load Balancer."
#   value       = yandex_alb_load_balancer.devops_coursework_alb.listener[0].endpoint[0].external_ipv4_address[0].address
# }


# output "bastion_public_ip" {
#   value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  
# }