resource "aws_security_group" "public_subent_sg" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  name        = "public_subent_sg"
  description = "allow traffic from public internet"
  vpc_id      = aws_vpc.application_vpc.id

  tags = {
    Name = "allow_http_https"
  }
}

resource "aws_security_group_rule" "public_subent_sg_rule_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_subent_sg[0].id
}

resource "aws_security_group_rule" "public_subent_sg_rule_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_subent_sg[0].id
}



resource "aws_security_group" "private_subent_sg" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  name        = "private_subent_sg"
  description = "allow traffic from public internet"
  vpc_id      = aws_vpc.application_vpc.id

  tags = {
    Name = "allow_only_from_public_subent_sg"
  }
}

resource "aws_security_group_rule" "private_subent_sg_rule_allow_postgres" {
  type              = "ingress"
  from_port         = 80
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.private_subent_sg[0].id
  source_security_group_id = aws_security_group.public_subent_sg[0].id
}