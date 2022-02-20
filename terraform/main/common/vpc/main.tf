locals {
  meta = {
    crew     = "pickstudio",
    team     = "platform",
    resource = "VPC"
    repository = "pickstudio/infrastructure"
  }

  cidr_block = "10.128.0.0/16"
}

resource "aws_vpc" "pickstudio" {
  cidr_block = local.cidr_block
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name     = local.meta.crew,
    Crew     = local.meta.crew,
    Team     = local.meta.team,
    Resource = local.meta.resource,
    Repository = local.meta.repository,
  }
}

resource "aws_internet_gateway" "pickstudio" {
  vpc_id = aws_vpc.pickstudio.id

  tags = {
    Name = "${local.meta.crew}-igw"
  }
}

resource "aws_security_group" "members" {
  name        = "members"
  description = "access for pickstudio crews"
  vpc_id      = aws_vpc.pickstudio.id

  tags = {
    Name     = "pickstudio-members",
    Crew     = local.meta.crew,
    Team     = local.meta.team,
    Resource = "security_group",
    Repository = local.meta.repository,
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "basic" {
  name        = "basic"
  description = "default security_group"
  vpc_id      = aws_vpc.pickstudio.id

  tags = {
    Name     = "pickstudio-basic",
    Crew     = local.meta.crew,
    Team     = local.meta.team,
    Resource = "security_group",
    Repository = local.meta.repository,
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  ingress {
    security_groups = [aws_security_group.members.id]
    from_port       = 0
    to_port         = 0
    protocol        = -1
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # VPC 피어링한 상대의 vpc id로 지정할수 없음.
  # https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-security-groups.html
  # ingress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = -1
  #   cidr_blocks = ["${var.peering_cidrs}"]
  # }
}


resource "aws_security_group" "public-for-test" {
  name        = "public-for-test"
  description = "access for pickstudio crews"
  vpc_id      = aws_vpc.pickstudio.id

  tags = {
    Name     = "pickstudio-public-for-test",
    Crew     = local.meta.crew,
    Team     = local.meta.team,
    Resource = "security_group",
    Repository = local.meta.repository,
  }

  ingress {
    security_groups = [
      aws_security_group.members.id,
      aws_security_group.basic.id,
    ]
    from_port       = 0
    to_port         = 0
    protocol        = -1
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

