output "strapi_public_ip" {
  value = aws_instance.strapi_ec2.public_ip
}
