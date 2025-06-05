# # modules/network/main.tf

# # VPC
# resource "aws_vpc" "main" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   # tags = merge(var.common_tags, {
#   #   Name = var.vpc_name
#   # })
#     tags = {
#     Name            = var.vpc_name
#     owner           = "Sara.Golombeck"
#     expiration_date = "01-07-2025"
#     Bootcamp        = "BC24"
#   }

# }

# # Internet Gateway
# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id

#   tags = merge(var.common_tags, {
#     Name = "${var.vpc_name}-igw"
#   })
# }

# # Public Subnets
# resource "aws_subnet" "public" {
#   count = length(var.public_subnet_cidrs)

#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = var.public_subnet_cidrs[count.index]
#   availability_zone       = var.availability_zones[count.index]
#   map_public_ip_on_launch = true

#   tags = merge(var.common_tags, {
#     Name                     = "${var.vpc_name}-public-subnet-${count.index + 1}"
#     Type                     = "public"
#     "kubernetes.io/role/elb" = "1"
#   })
# }

# # Private Subnets
# resource "aws_subnet" "private" {
#   count = length(var.private_subnet_cidrs)

#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = merge(var.common_tags, {
#     Name                              = "${var.vpc_name}-private-subnet-${count.index + 1}"
#     Type                              = "private"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   })
# }

# # Elastic IPs for NAT Gateways
# resource "aws_eip" "nat" {
#   count = length(var.public_subnet_cidrs)

#   domain = "vpc"
#   depends_on = [aws_internet_gateway.main]

#   tags = merge(var.common_tags, {
#     Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
#   })
# }

# # NAT Gateways
# resource "aws_nat_gateway" "main" {
#   count = length(var.public_subnet_cidrs)

#   allocation_id = aws_eip.nat[count.index].id
#   subnet_id     = aws_subnet.public[count.index].id

#   tags = merge(var.common_tags, {
#     Name = "${var.vpc_name}-nat-${count.index + 1}"
#   })

#   depends_on = [aws_internet_gateway.main]
# }

# # Public Route Table
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }

#   tags = merge(var.common_tags, {
#     Name = "${var.vpc_name}-public-rt"
#   })
# }

# # Private Route Tables
# resource "aws_route_table" "private" {
#   count = length(var.private_subnet_cidrs)

#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main[count.index].id
#   }

#   tags = merge(var.common_tags, {
#     Name = "${var.vpc_name}-private-rt-${count.index + 1}"
#   })
# }

# # Public Route Table Associations
# resource "aws_route_table_association" "public" {
#   count = length(aws_subnet.public)

#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# # Private Route Table Associations
# resource "aws_route_table_association" "private" {
#   count = length(aws_subnet.private)

#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private[count.index].id
# }



# modules/network/main.tf 

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name            = "sara-vpc"
    owner           = "Sara.Golombeck"
    expiration_date = "01-07-2025"
    Bootcamp        = "BC24"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "${var.vpc_name}-igw"
    owner           = "Sara.Golombeck"
    expiration_date = "01-07-2025"
    Bootcamp        = "BC24"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.vpc_name}-public-${count.index + 1}"
    # Type                                        = "Public"
    owner                                       = "Sara.Golombeck"
    expiration_date                            = "01-07-2025"
    Bootcamp                                   = "BC24"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}


# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name            = "${var.vpc_name}-public-rt"
    owner           = "Sara.Golombeck"
    expiration_date = "01-07-2025"
    Bootcamp        = "BC24"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}