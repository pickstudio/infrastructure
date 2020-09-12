
resource "aws_internet_gateway" "pickstudio" {
  vpc_id = aws_vpc.pickstudio.id

  tags = {
    Name = local.name
  }
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.pickstudio]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pickstudio.id

  tags = {
    Name = "${local.name}-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pickstudio.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.pickstudio.id

  tags = {
    Name = "${local.name}-private"
  }
}
