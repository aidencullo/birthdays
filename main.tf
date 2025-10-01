module "watereye_web" {
  source        = "./modules/ec2-instance"
  environment   = var.environment
}

