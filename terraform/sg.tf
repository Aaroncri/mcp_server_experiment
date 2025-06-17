#########################################################
############    Jump Box Security Group  ################
#########################################################

resource "aws_security_group" "SG_jump" {
  name        = "SG-jump"
  description = "Security Group for the jump box. SSH from anywhere; egress limited to DNS/HTTP/HTTPS."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "SG-jump"
  }
}

# Ingress: SSH from anywhere
resource "aws_vpc_security_group_ingress_rule" "jump_allow_ssh" {
  security_group_id = aws_security_group.SG_jump.id
  description       = "Allow SSH from anywhere"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

# Egress: DNS → VPC resolver
resource "aws_security_group_rule" "jump_egress_dns" {
  type              = "egress"
  description       = "Allow DNS (UDP 53) outbound to VPC resolver"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.SG_jump.id
  cidr_blocks       = ["${cidrhost(var.main_vpc_cidr_block, 2)}/32"]
}

# Egress: HTTP → internet
resource "aws_security_group_rule" "jump_egress_http" {
  type              = "egress"
  description       = "Allow HTTP (TCP 80) outbound"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_jump.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Egress: HTTPS → internet
resource "aws_security_group_rule" "jump_egress_https" {
  type              = "egress"
  description       = "Allow HTTPS (TCP 443) outbound"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_jump.id
  cidr_blocks       = ["0.0.0.0/0"]
}
# Egress SSH
resource "aws_security_group_rule" "jump_egress_ssh_to_private" {
  type              = "egress"
  description       = "Allow SSH to private subnet containing agent and mcp server"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_jump.id
  cidr_blocks       = [var.private_subnet_cidr_block]
}


#########################################################
##########      Agent Security Group      ############
#########################################################

resource "aws_security_group" "SG_agent" {
  name        = "SG-agent"
  description = "Security Group for the agent instance. SSH & UI inbound; egress limited to DNS/HTTP/HTTPS."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "SG-agent"
  }
}

# Ingress: SSH from anywhere
resource "aws_vpc_security_group_ingress_rule" "agent_allow_ssh" {
  security_group_id = aws_security_group.SG_agent.id
  description       = "Allow SSH from anywhere"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

# Ingress: agent UI port
resource "aws_vpc_security_group_ingress_rule" "agent_allow_ui" {
  security_group_id = aws_security_group.SG_agent.id
  description       = "Allow agent UI (TCP 7860) from anywhere"
  ip_protocol       = "tcp"
  from_port         = 7860
  to_port           = 7860
  cidr_ipv4         = "0.0.0.0/0"
}

# Egress: DNS → VPC resolver
resource "aws_security_group_rule" "agent_egress_dns" {
  type              = "egress"
  description       = "Allow DNS (UDP 53) outbound to VPC resolver"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.SG_agent.id
  cidr_blocks       = ["${cidrhost(var.main_vpc_cidr_block, 2)}/32"]
}

# Egress: HTTP → internet
resource "aws_security_group_rule" "agent_egress_http" {
  type              = "egress"
  description       = "Allow HTTP (TCP 80) outbound"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_agent.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Egress: HTTPS → internet
resource "aws_security_group_rule" "agent_egress_https" {
  type              = "egress"
  description       = "Allow HTTPS (TCP 443) outbound"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_agent.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#########################################################
##########      MCP Security Group      ############
#########################################################

resource "aws_security_group" "SG_mcp" {
  name        = "SG-mcp"
  description = "Security Group for the mcp instance. SSH & UI inbound; egress limited to DNS/HTTP/HTTPS."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "SG-mcp"
  }
}

# Ingress: SSH from anywhere
resource "aws_vpc_security_group_ingress_rule" "mcp_allow_ssh" {
  security_group_id = aws_security_group.SG_mcp.id
  description       = "Allow SSH from anywhere"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

# Ingress: mcp UI port
resource "aws_vpc_security_group_ingress_rule" "mcp_allow_ui" {
  security_group_id = aws_security_group.SG_mcp.id
  description       = "Allow mcp UI (TCP 7860) from anywhere"
  ip_protocol       = "tcp"
  from_port         = 7860
  to_port           = 7860
  cidr_ipv4         = "0.0.0.0/0"
}

# Egress: DNS → VPC resolver
resource "aws_security_group_rule" "mcp_egress_dns" {
  type              = "egress"
  description       = "Allow DNS (UDP 53) outbound to VPC resolver"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.SG_mcp.id
  cidr_blocks       = ["${cidrhost(var.main_vpc_cidr_block, 2)}/32"]
}

# Egress: HTTP → internet
resource "aws_security_group_rule" "mcp_egress_http" {
  type              = "egress"
  description       = "Allow HTTP (TCP 80) outbound"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_mcp.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Egress: HTTPS → internet
resource "aws_security_group_rule" "mcp_egress_https" {
  type              = "egress"
  description       = "Allow HTTPS (TCP 443) outbound"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.SG_mcp.id
  cidr_blocks       = ["0.0.0.0/0"]
}
