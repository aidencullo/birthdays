locals {
  app_fqdn    = "${var.subdomain}.${var.root_domain}"
  origin_name = "${var.subdomain}-origin.${var.root_domain}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${var.env_name}-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "instance" {
  name        = "${var.env_name}-instance-sg"
  description = "Instance security group (${var.env_name})."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = length(var.allowed_ssh_cidrs) > 0 ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.env_name
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    dnf -y update
    dnf -y install nginx
    systemctl enable nginx
    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!doctype html>
    <html>
      <head><meta charset="utf-8"><title>${var.env_name}</title></head>
      <body style="font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;">
        <h1>${var.env_name} environment</h1>
        <p>Origin: ${local.origin_name}</p>
      </body>
    </html>
    HTML
    systemctl start nginx
  EOF

  tags = {
    Name        = "${var.env_name}-instance"
    Environment = var.env_name
  }
}

resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    Name        = "${var.env_name}-eip"
    Environment = var.env_name
  }
}

resource "aws_eip_association" "this" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this.id
}

resource "aws_route53_record" "origin" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain}-origin"
  type    = "A"
  ttl     = 60
  records = [aws_eip.this.public_ip]
}

resource "aws_acm_certificate" "this" {
  provider          = aws.us_east_1
  domain_name       = local.app_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

data "aws_cloudfront_cache_policy" "managed_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "managed_cors_s3_origin" {
  name = "Managed-CORS-CustomOrigin"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.env_name} distribution"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = [local.app_fqdn]

  origin {
    domain_name = local.origin_name
    origin_id   = "origin-${var.env_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "origin-${var.env_name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.managed_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed_cors_s3_origin.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.this.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  depends_on = [aws_acm_certificate_validation.this]
}

resource "aws_route53_record" "app" {
  zone_id = var.hosted_zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "random_password" "db" {
  count   = var.create_db ? 1 : 0
  length  = 24
  special = true
}

resource "aws_security_group" "db" {
  count       = var.create_db ? 1 : 0
  name        = "${var.env_name}-db-sg"
  description = "DB security group (${var.env_name})."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Postgres from instance"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.instance.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.env_name
  }
}

resource "aws_db_subnet_group" "this" {
  count      = var.create_db ? 1 : 0
  name       = "${var.env_name}-db-subnets"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Environment = var.env_name
  }
}

resource "aws_db_instance" "this" {
  count = var.create_db ? 1 : 0

  identifier             = "${var.env_name}-db"
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "app"
  username               = "appuser"
  password               = random_password.db[0].result
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.this[0].name
  vpc_security_group_ids = [aws_security_group.db[0].id]

  publicly_accessible        = false
  multi_az                   = false
  deletion_protection        = false
  skip_final_snapshot        = true
  backup_retention_period    = 0
  apply_immediately          = true
  auto_minor_version_upgrade = true

  tags = {
    Environment = var.env_name
  }
}

resource "aws_secretsmanager_secret" "db" {
  count = var.create_db ? 1 : 0
  name  = "${var.env_name}/db"
  tags = {
    Environment = var.env_name
  }
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.create_db ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[0].id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_db_instance.this[0].address
    port     = aws_db_instance.this[0].port
    dbname   = aws_db_instance.this[0].db_name
    username = aws_db_instance.this[0].username
    password = random_password.db[0].result
  })
}

