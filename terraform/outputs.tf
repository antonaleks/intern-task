output "server_outputs" {
  value = [
    "Web App IP address - ${module.preemptible_server.0.floating_ip}",
    "Database IP address - ${module.preemptible_server.1.floating_ip}",
    "ssh root@${module.preemptible_server.0.floating_ip}",
    "ssh root@${module.preemptible_server.1.floating_ip}"
  ]
}
