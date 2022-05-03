# --- networking/main.tf ---

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "jessew_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "jessew_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "jessew_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.jessew_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "jessew_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "jessew_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.jessew_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.jessew_public_rt.id
}

resource "aws_subnet" "jessew_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.jessew_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "jessew_private_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "jessew_internet_gateway" {
  vpc_id = aws_vpc.jessew_vpc.id

  tags = {
    Name = "jessew_igw"
  }
}

resource "aws_route_table" "jessew_public_rt" {
  vpc_id = aws_vpc.jessew_vpc.id

  tags = {
    Name = "jessew_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.jessew_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jessew_internet_gateway.id
}

resource "aws_default_route_table" "jessew_private_rt" {
  default_route_table_id = aws_vpc.jessew_vpc.default_route_table_id

  tags = {
    Name = "jessew_private"
  }
}

resource "aws_security_group" "jessew_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.jessew_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "jessew_rds_subnetgroup" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "jessew_rds_subnetgroup"
  subnet_ids = aws_subnet.jessew_private_subnet.*.id
  tags = {
    Name = "jessew_rds_sng"
  }
}