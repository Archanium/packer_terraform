provider "aws" {
  region = var.region
  version = "~> 2.40"
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_instance" "server" {
  availability_zone = data.aws_availability_zones.available.names[0]
  ami = data.aws_ami.java_server_ami.id
  instance_type = "t3.medium"
  ebs_optimized = true
  // TODO: Fill this out with the name of the keypair in AWS
  key_name = ""
  root_block_device {
    // File storage needed
    volume_size = 20
    volume_type = "gp2"
  }
  lifecycle {
    create_before_destroy = true
  }
  provisioner "file" {
    destination = "/home/ubuntu/base_env"
    content = <<EOF
#SQL
export DB_HOST="${module.rds-database.this_db_instance_address}"
export DB_NAME="${module.rds-database.this_db_instance_name}"
export DB_USER="${module.rds-database.this_db_instance_username}"
export DB_PASS="${module.rds-database.this_db_instance_password}"

EOF

  }
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "ubuntu"
    // TODO: This path should be the private key for the corresponding key pair above.
    private_key = file("terraform_key")

  }
}

resource "aws_eip_association" "nginx_ip" {
  instance_id = aws_instance.server.id
  allocation_id = aws_eip.current_ip.id
  allow_reassociation = true
  depends_on = [
    aws_instance.server]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "current_ip" {
  vpc = true
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_ami" "java_server_ami" {
  most_recent = true

  filter {
    name = "tag:ami"
    values = [
      "java_server",
    ]
  }

  owners = [
    "self",
  ]
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key = "network/terraform.tfstate"
    region = var.region
  }
}

terraform {
  backend "s3" {
    bucket = var.bucket_name
    key = "network/terraform.tfstate"
    region = var.region
  }
}

output "public_ip" {
  value = aws_eip.current_ip.public_ip
}

