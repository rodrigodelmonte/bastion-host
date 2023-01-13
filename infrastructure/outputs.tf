output "ssh_command" {
  value = format("ssh -i ssh_key ubuntu@%s", module.ec2_instance.public_ip)
}