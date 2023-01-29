resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.vpc_main.id

    tags = {
      "Name" = "${var.region}-igw"
    }
}

# Build NAT gateway for AZ A
resource "aws_eip" "main_eip_a" {
    vpc = true

    tags = {
      "Name" = "${var.region}a-eip"
    }

    depends_on = [
      aws_internet_gateway.main_igw
    ]
}

resource "aws_nat_gateway" "main_nat_a" {
    allocation_id = aws_eip.main_eip_a.id
    subnet_id = aws_subnet.main_public_a.id

    tags = {
      "Name" = "${var.region}_main_nat_a"
    }

    depends_on = [
      aws_internet_gateway.main_igw
    ]
}

# Build NAT gateway for AZ B
resource "aws_eip" "main_eip_b" {
    vpc = true

    tags = {
      "Name" = "${var.region}b-eip"
    }

    depends_on = [
      aws_internet_gateway.main_igw
    ]
}

resource "aws_nat_gateway" "main_nat_b" {
    allocation_id = aws_eip.main_eip_b.id
    subnet_id = aws_subnet.main_public_b.id

    tags = {
      "Name" = "${var.region}_main_nat_b"
    }

    depends_on = [
      aws_internet_gateway.main_igw
    ]
}