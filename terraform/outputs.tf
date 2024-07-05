output "aws_ecr_repo_url" {
  value = aws_ecr_repository.webapp.repository_url
}

output "webapp_hostname" {
  value = aws_route53_record.wepapp.fqdn
}