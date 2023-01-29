# Create Main VPC subnets
resource "aws_subnet" "main_private_a" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "${var.region}a"

    tags = {
      "Name" = "python-predictions-${var.environment}-${var.region}a-main-private"
    }
}

resource "aws_subnet" "main_private_b" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}b"

    tags = {
      "Name" = "python-predictions-${var.environment}-${var.region}b-main-private"
    }
}

resource "aws_subnet" "main_private_c" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}c"

    tags = {
      "Name" = "python-predictions-${var.environment}-${var.region}c-main-private"
    }
}

resource "aws_subnet" "main_public_a" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.region}a"

    tags = {
        "Name" = "python-predictions-${var.environment}-${var.region}a-public"
    }
}

resource "aws_subnet" "main_public_b" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.region}b"

    tags = {
        "Name" = "python-predictions-${var.environment}-${var.region}b-public"
    }
}

resource "aws_subnet" "main_public_c" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.region}c"

    tags = {
        "Name" = "python-predictions-${var.environment}-${var.region}c-public"
    }
}