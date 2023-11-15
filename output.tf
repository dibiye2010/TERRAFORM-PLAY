output "instance_terra-ec2_public_ip" {
  value = aws_instance.terra-ec2[*].public_ip
}

output "instance_terra-ec2_public_dns" {
  value = aws_instance.terra-ec2[*].public_dns
}