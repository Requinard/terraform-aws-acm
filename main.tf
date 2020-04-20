terraform {
  required_providers {
    aws = ">=2.56.0"
    null = ">=2.1.2"
  }
}

resource "null_resource" "dns_check" {
  count = data.aws_region.region.name == "us-east-1" ? 0 : 1

  provisioner "local-exec" {
    command = "false"
    interpreter = [
      "bash",
      "-c"]
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name = var.main_domain
  validation_method = "DNS"
  subject_alternative_names = var.secondary_domains
  tags = var.tags
  depends_on = [
    null_resource.dns_check
  ]
}

resource "aws_route53_record" "cert_validation" {
  count = length(local.domains_total)

  name = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_name
  type = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [
    aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
