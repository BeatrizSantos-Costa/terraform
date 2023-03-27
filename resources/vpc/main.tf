data "aws_availability_zones" "available" {
  state = "available"
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "vpc_terraform" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, { "Name" = "OpenVPN" })
}

resource "aws_internet_gateway" "igw_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = merge(var.tags, { "Name" = "igw-openVPN" })
}

resource "aws_route_table" "public_rt_table" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = var.route_public_cidr_block
    gateway_id = aws_internet_gateway.igw_terraform.id
  }

  tags = merge(var.tags, { "Name" = "rt-openVPN-public" })
}

resource "aws_route_table" "private_rt_table" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = var.route_private_cidr_block
    gateway_id = element(aws_nat_gateway.nat_gw.*.id, 0)
  }

  tags = merge(var.tags, { "Name" = "rt-openVPN-private" })
}

resource "aws_route_table_association" "assoc_public_a" {
  count          = length(var.subnets_cidrs_block_public)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt_table.id
}



resource "aws_route_table_association" "assoc_private_a" {
  count          = length(var.subnets_cidrs_block_private)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt_table.id
}


################################################################################
# VPC Flow Logs S3
################################################################################

resource "aws_flow_log" "aws_flow_logs_s3" {
  log_destination            = var.log_destination
  log_destination_type       = var.log_destination_type
  traffic_type               = var.traffic_type
  vpc_id                     = aws_vpc.vpc_terraform.id
  deliver_cross_account_role = var.deliver_cross_account_role
  tags                       = merge(var.tags, { "Name" = "flowlogs-openVPN" })
}


################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat_gw_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw_terraform]
  tags       = merge(var.tags, { "Name" = "eip-openVPN" })
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = merge(var.tags, { "Name" = "nat-openVPN" })

  depends_on = [aws_internet_gateway.igw_terraform]
}

################################################################################
# Subnet
################################################################################

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  count                   = length(var.subnets_cidrs_block_public)
  cidr_block              = element(var.subnets_cidrs_block_public, count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, { "Name" = "subnet-openVPN-public" })
}


resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  count                   = length(var.subnets_cidrs_block_private)
  cidr_block              = element(var.subnets_cidrs_block_private, count.index)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, { "Name" = "subnet-openVPN-private" })
}