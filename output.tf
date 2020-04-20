output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}

output "domains" {
  value = aws_acm_certificate_validation.cert.validation_record_fqdns
}
