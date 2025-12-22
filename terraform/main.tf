data "aws_route53_zone" "this" {
  count        = var.hosted_zone_id == null ? 1 : 0
  name         = "${var.root_domain}."
  private_zone = false
}

locals {
  zone_id = coalesce(var.hosted_zone_id, try(data.aws_route53_zone.this[0].zone_id, null))
}

module "dev" {
  source = "./modules/minimal_env"

  env_name          = "dev"
  subdomain         = "dev"
  root_domain       = var.root_domain
  hosted_zone_id    = local.zone_id
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  ssh_public_key    = var.ssh_public_key
  instance_type     = var.instance_type
  create_db         = var.dev_create_db

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}

module "test" {
  source = "./modules/minimal_env"

  env_name          = "test"
  subdomain         = "test"
  root_domain       = var.root_domain
  hosted_zone_id    = local.zone_id
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  ssh_public_key    = var.ssh_public_key
  instance_type     = var.instance_type
  create_db         = var.test_create_db

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}

