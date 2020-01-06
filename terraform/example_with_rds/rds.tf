module "rds-database" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "t-database"

  engine = "mariadb"
  engine_version = "10.2.21"
  instance_class = "db.t2.small"
  allocated_storage = 5

  name = "tdatabase"
  username = "t_database"
  password = "${var.env_db_pass}"
  port = "3306"
  availability_zone = "eu-central-1a"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-06:00"

  tags = {
  }
  # DB parameter group
  family = "mariadb10.2"

  # DB option group
  major_engine_version = "10.2"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "t-database"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    },
    {
      name = "max_allowed_packet"
      value = "16777216"
    }
  ]
  vpc_security_group_ids = [
    aws_security_group.sg-allow-mariadb.id
  ]
  db_subnet_group_name = aws_db_subnet_group.mariadb-subnet.name
}

resource "aws_db_subnet_group" "mariadb-subnet" {
  name = "${(lower(var.vpc_key))}-mariadb-subnet"
  description = "RDS subnet group"
  subnet_ids = [
    aws_subnet.main_vpc-private-1.id,
    aws_subnet.main_vpc-private-2.id,]
}


