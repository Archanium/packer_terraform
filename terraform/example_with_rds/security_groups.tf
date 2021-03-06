resource "aws_security_group" "sg-allow-mariadb" {
  vpc_id = aws_vpc.main_vpc.id
  name = "${var.vpc_key}-sg-allow-mariadb"
  description = "allow-mariadb"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [
      aws_security_group.sg-web.id]
    # allowing access from our example instance
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
    self = true
  }
  tags = {
    Name = "allow-mariadb",
    VPC_KEY = var.vpc_key
  }
}

resource "aws_security_group" "sg-web" {
  vpc_id = aws_vpc.main_vpc.id
  name = "${var.vpc_key}-sg-web"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  tags = {
    VPC_KEY = "${var.vpc_key}"
  }
}

resource "aws_security_group" "sg-ssh" {
  vpc_id = aws_vpc.main_vpc.id
  name = "${var.vpc_key}-sg-ssh"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  tags = {
    VPC_KEY = "${var.vpc_key}"
  }
}

resource "aws_security_group" "sg-swarm" {
  name        = "${var.vpc_key}-sg-swarm"
  description = "Security group for swarm cluster instances"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 2375
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main_vpc.cidr_block
    ]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main_vpc.cidr_block
    ]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [
      aws_vpc.main_vpc.cidr_block
    ]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main_vpc.cidr_block
    ]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [
      aws_vpc.main_vpc.cidr_block
    ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.vpc_key}-sg-swarm"
    VPC = "${var.vpc_key}"
    Terraform = "Terraform"
    VPC_KEY = "${var.vpc_key}"
  }
}

output "sg_swarm" {
  value = "${aws_security_group.sg-swarm.id}"
}