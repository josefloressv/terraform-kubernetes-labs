provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.provider_default_tags
  }
}

locals {
  amazon_ami_by_regions = {
    "us-east-1" = "ami-0747bdcabd34c712a", # N. Virginia
    "us-east-2" = "ami-00399ec92321828f5", # Ohio
    "us-west-1" = "ami-0d382e80be7ffdae5", # N. California
    "us-west-2" = "ami-03d5c68bab01f3496", # Oregon
  }
}

# Networking
# ----------------------------
resource "aws_vpc" "vpc01" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

#   Subnet: public subnets
resource "aws_subnet" "sn" {
  count                   = length(var.public_subnet_cidr_block)
  vpc_id                  = aws_vpc.vpc01.id
  cidr_block              = var.public_subnet_cidr_block[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.public_azs[count.index]
  tags = {
    Name = format("%s%s", var.sn_name_prefix, count.index)
  }
}

#   Gateway
resource "aws_internet_gateway" "ig01" {
  vpc_id = aws_vpc.vpc01.id
  tags = {
    Name = var.igw_name
  }
}

#   Routing table
resource "aws_route_table" "rt01" {
  vpc_id = aws_vpc.vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig01.id
  }
  tags = {
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "rta01" {
  count          = length(var.public_subnet_cidr_block)
  subnet_id      = aws_subnet.sn[count.index].id
  route_table_id = aws_route_table.rt01.id
}

#   Security Group
resource "aws_security_group" "sg01" {
  vpc_id = aws_vpc.vpc01.id
  name   = var.sg01_name

  dynamic "ingress" {
    for_each = var.sg01_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    description = "Allow all for egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.sg01_tags
}

# Instances
# ----------------------------

resource "aws_instance" "control" {
  instance_type          = var.default_instance_type
  subnet_id              = aws_subnet.sn[0].id
  ami                    = local.amazon_ami_by_regions[var.aws_region]
  vpc_security_group_ids = [aws_security_group.sg01.id]
  key_name               = var.default_instance_key_name
  user_data              = templatefile("user_data_nodes.tftpl", { host_name = var.cluster_control_name})
  tags = merge(
    var.default_instance_os_tag,
    {
      Name = var.cluster_control_name
  })
}


resource "aws_instance" "node" {
  count                  = length(var.public_subnet_cidr_block) - 1
  instance_type          = var.default_instance_type
  subnet_id              = aws_subnet.sn[count.index + 1].id
  ami                    = local.amazon_ami_by_regions[var.aws_region]
  vpc_security_group_ids = [aws_security_group.sg01.id]
  key_name               = var.default_instance_key_name
  user_data              = templatefile("user_data_nodes.tftpl", { host_name = format("%s%s", var.cluster_node_prefix_name, count.index + 1)})
  tags = merge(
    var.default_instance_os_tag,
    {
      Name = format("%s%s", var.cluster_node_prefix_name, count.index + 1)
  })
}