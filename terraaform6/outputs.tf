output "strapi_url" {
  description = "Public URL of the Strapi application"
  value       = aws_lb.madhan_strapi_alb.dns_name
}
