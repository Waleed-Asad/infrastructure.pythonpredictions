resource "aws_route_table" "main_public_a" {
  vpc_id = aws_vpc.vpc_main.id
  
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.main_igw.id
  }
  
  tags = {
    Name = "python-predictions-${var.environment}-${var.region}a-main-public"
  }   
}

resource "aws_route_table_association" "main_public_a" {
  subnet_id = aws_subnet.main_public_a.id
  route_table_id = aws_route_table.main_public_a.id
}

resource "aws_route_table" "main_public_b" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "python-predictions-${var.environment}-${var.region}b-main-public"
  }
}

resource "aws_route_table_association" "main_public_b" {
  subnet_id = aws_subnet.main_public_b.id
  route_table_id = aws_route_table.main_public_b.id
}

resource "aws_route_table" "main_public_c" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "python-predictions-${var.environment}-${var.region}c-main-public"
  }
}

resource "aws_route_table_association" "main_public_c" {
  subnet_id = aws_subnet.main_public_c.id
  route_table_id = aws_route_table.main_public_c.id
}


resource "aws_route_table" "main_private_a" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.main_nat_a.id
  }
  tags = {
    Name = "python-predictions-${var.environment}-${var.region}a-main-private"
  }
}

resource "aws_route_table_association" "main_private_a" {
  subnet_id = aws_subnet.main_private_a.id
  route_table_id = aws_route_table.main_private_a.id
}


resource "aws_route_table" "main_private_b" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.main_nat_b.id
  }
  tags = {
    Name = "python-predictions-${var.environment}-${var.region}b-main-private"
  }
}

resource "aws_route_table_association" "main_private_b" {
  subnet_id = aws_subnet.main_private_b.id
  route_table_id = aws_route_table.main_private_b.id
}

resource "aws_route_table" "main_private_c" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.main_nat_b.id
  }
  tags = {
    Name = "python-predictions-${var.environment}-${var.region}b-main-private"
  }
}

resource "aws_route_table_association" "main_private_c" {
  subnet_id = aws_subnet.main_private_c.id
  route_table_id = aws_route_table.main_private_c.id
}