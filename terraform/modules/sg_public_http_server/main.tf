
resource "aws_security_group" "sg" {
  name        = "${var.meta.service}-${var.meta.role}-${var.meta.env}"
  description = "Picka ALB SG for service"
  vpc_id      = var.vpc_id

  tags = {
    crew     = var.meta.crew,
    team     = var.meta.team,
    resource = "security group",
    env      = var.meta.env,
    role     = "sg",
    service = var.meta.service,
  }
}

resource "aws_security_group_rule" "sg-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "sg-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}


resource "aws_security_group_rule" "sg-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}