variable "main_domain" {
  description = "The main domain to get a certificate for"
  type = string
}

variable "secondary_domains" {
  description = "Secondary domains to include in the certificate"
  type = list(string)
  default = []
}

variable "tags" {
  type = map(string)
  description = "Tags to attach to created resources"
  default = {}
}

variable "zone" {
  type = string
  description = "Hosted zone that can host DNS validation"
}

data "aws_region" "region" {}

data "aws_route53_zone" "zone" {
  name = var.zone
}

locals {
  domains_total = concat([
    var.main_domain], var.secondary_domains)
}
