# Dependent variables
# ----------------------------
aws_region                = "us-east-2" # US East (Ohio)
vpc_cidr_block            = "10.0.0.0/16"
public_azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
public_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
default_instance_key_name = "k8s-ohio"

# Global
# ----------------------------
default_instance_type = "t2.medium"
provider_default_tags = {
  Environment = "staging",
  Terraform   = true
}

# Networking
# ----------------------------
vpc_name = "vpc-k8slab"

#    Subnets

sn_name_prefix = "sn-public-k9slab-"

#    Internet Gateway
igw_name = "ig-vpc-k8slab"

#     Routing Table   
rt_name = "rt01-wig-k8slab"

#     Security Group
sg01_name = "k8slab-sg"
sg01_ingress = [{
  description = "Allow port 22"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16", "190.86.109.131/32"]
  }, {
  description = "Allow port HTTP"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  }, {
  description = "Allow ICMP"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["10.0.0.0/16", "190.86.109.131/32"]
}, {
  description = "Kubernete API Server"
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}, {
  description = "Kubernete API Server"
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}, {
  description = "etcd server client API"
  from_port   = 2379
  to_port     = 2380
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}, {
  description = "kubelet API"
  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}, {
  description = "kube-scheduler"
  from_port   = 10251
  to_port     = 10251
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}, {
  description = "kube-controller-manager"
  from_port   = 10252
  to_port     = 10252
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}, {
  description = "NodePort Services"
  from_port   = 30000
  to_port     = 32767
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}]

sg01_tags = {
  Name = "sg-01-k8slab"
  Info = "Allow SSH & HTTP & ICMP"
}

# Instances
# ----------------------------
cluster_control_name     = "k8slab-control"
cluster_node_prefix_name = "k8slab-node-"
default_instance_os_tag = {
  OperatingSystem = "Ubuntu 18.04"
}

# Load Balancer
# ----------------------------
alb_name    = "alb-tf-01-wwww"
alb_tg_name = "albtg-webs"

