# Outputs
output "control_public_ip" {
  value = aws_instance.control.public_ip
}

output "control_private_ip" {
  value = aws_instance.control.private_ip
}

output "worker_node_public_ip" {
  value = aws_instance.node[*].public_ip
}

output "worker_node_private_ip" {
  value = aws_instance.node[*].private_ip
}
