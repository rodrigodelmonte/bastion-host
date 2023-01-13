module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.name
  cidr = "10.0.0.0/16"

  azs             = var.aws_availability_zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = var.tags

}

resource "aws_security_group" "bastion" {
  description = "Allow inbound SSH."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_key_pair" "main" {
  key_name_prefix = "advanced-tests-bastion-host"
  public_key      = file(format("%s.%s", var.ssh_key, "pub"))
}

data "template_file" "user_data" {
  template = file("../scripts/install.sh")
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name = var.name

  ami                         = "ami-07eeacb3005b9beae"
  instance_type               = "t3a.large"
  key_name                    = aws_key_pair.main.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered
  tags                        = var.tags

  depends_on = [
    module.vpc
  ]
}