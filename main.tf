module "watereye_web" {
  source        = "./modules/ec2-instance"
  environment   = var.environment
  instance_type = var.instance_type
  ami_id        = var.ami_id
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  iam_role_name = var.iam_role_name
  user_data = templatefile("${path.module}/../../src/user-data.sh", {
    GITLAB_TOKEN = var.gitlab_token,
    ARTIFACT_URL = var.artifact_url
    }
  )
}

