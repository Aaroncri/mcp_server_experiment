#########################################################
###############    Public Subnet NACL   #################
#########################################################

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-subnet-nacl"
  }
}

resource "aws_network_acl_association" "public_assoc" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.main-public.id
}

# Ingress: SSH (TCP 22)
resource "aws_network_acl_rule" "public_in_ssh" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Ingress: HTTP (TCP 80)
resource "aws_network_acl_rule" "public_in_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Ingress: HTTPS (TCP 443)
resource "aws_network_acl_rule" "public_in_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Ingress: Ephemeral TCP (1024–65535)
resource "aws_network_acl_rule" "public_in_ephemeral_tcp" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 130
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Ingress: Ephemeral UDP (1024–65535)
resource "aws_network_acl_rule" "public_in_ephemeral_udp" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 140
  protocol       = "17"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Deny all other inbound
resource "aws_network_acl_rule" "public_in_deny_all" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 400
  protocol       = "-1"
  rule_action    = "deny"
  egress         = false
  cidr_block     = "0.0.0.0/0"
}

# Egress: Allow all outbound
resource "aws_network_acl_rule" "public_out_allow_all" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

# Deny all other outbound
resource "aws_network_acl_rule" "public_out_deny_all" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 400
  protocol       = "-1"
  rule_action    = "deny"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}


#########################################################
###############    Private Subnet NACL  #################
#########################################################

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-subnet-nacl"
  }
}

resource "aws_network_acl_association" "private_assoc" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.main-private.id
}

# 1) Allow SSH (TCP 22) from the jump box subnet
resource "aws_network_acl_rule" "private_in_ssh" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 90
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "10.0.1.0/24"
  from_port      = 22
  to_port        = 22
}

# 2) Ephemeral TCP for return traffic (1024–65535)
resource "aws_network_acl_rule" "private_in_ephemeral_tcp" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# 3) Ephemeral UDP for return traffic (1024–65535)
resource "aws_network_acl_rule" "private_in_ephemeral_udp" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  protocol       = "17"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# 4) Deny all other inbound
resource "aws_network_acl_rule" "private_in_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 400
  protocol       = "-1"
  rule_action    = "deny"
  egress         = false
  cidr_block     = "0.0.0.0/0"
}

# 5) Egress: Allow all outbound
resource "aws_network_acl_rule" "private_out_allow_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

# 6) Deny all other outbound
resource "aws_network_acl_rule" "private_out_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 400
  protocol       = "-1"
  rule_action    = "deny"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}
