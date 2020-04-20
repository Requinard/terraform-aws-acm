provider "aws" {
  profile = "requinard"
  region = "us-east-1"
}

module "test" {
  source = "../"
  zone = "aws.subjectreview.eu"
  main_domain = "test.aws.subjectreview.eu"
  secondary_domains = [
    "test2.aws.subjectreview.eu"
  ]
}
