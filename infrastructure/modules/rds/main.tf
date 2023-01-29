resource "aws_db_subnet_group" "event_driven_app" {
  name       = "${var.service}-db-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "Event driven app db subnet group"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.service}-db-security-group"
  description = "Event driven app db security group"
  vpc_id      = var.vpc_id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    # You have to change "0.0.0.0/0" to your own public IP address
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.lambda_security_group_id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Event driven app db security group"
  }
}


resource "random_password" "db_password" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "default" {
  allocated_storage                   = var.allocated_storage
  iam_database_authentication_enabled = true
  publicly_accessible                 = true
  apply_immediately                   = true
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  username                            = var.username
  password                            = random_password.db_password.result
  vpc_security_group_ids              = ["${aws_security_group.db.id}"]
  db_subnet_group_name                = aws_db_subnet_group.event_driven_app.name
  identifier                          = "${var.service}-db"
  skip_final_snapshot                 = true
  db_name                             = var.name
}

resource "aws_secretsmanager_secret" "event_driven_app_db_credentials" {
  name                    = "${var.service}-db-credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "event_driven_app_db_password" {
  secret_id = aws_secretsmanager_secret.event_driven_app_db_credentials.id
  secret_string = jsonencode({
    "DB_IAM_USER" : "${var.db_user}",
    "DB_USER" : "${aws_db_instance.default.username}",
    "DB_PASSWORD" : "${random_password.db_password.result}",
    "DB_ENGINE" : "${aws_db_instance.default.engine}",
    "DB_HOST" : "${aws_db_instance.default.address}",
    "DB_PORT" : "${aws_db_instance.default.port}",
    "DB_NAME" : "${aws_db_instance.default.db_name}",
  })
}


resource "aws_security_group" "vpc_endpoint_ssm" {
  name        = "${var.service}-ssm-vpc-endpoint-sg"
  description = "Event driven app ssm vpc endpoint security group"
  vpc_id      = var.vpc_id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.lambda_security_group_id]
  }
  # Allow all outbound traffic.
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.lambda_security_group_id]
  }
  tags = {
    Name = "Event driven app ssm vpc endpoint security group"
  }
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc_endpoint_ssm.id,
  ]

  subnet_ids = [var.private_subnet_a_id, var.private_subnet_b_id]

  private_dns_enabled = true

  tags = {
    Name = "Event driven app ssm vpc endpoint"
  }
}
