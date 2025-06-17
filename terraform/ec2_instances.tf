#########################################################
###############      Jump Box       #####################
#########################################################

resource "aws_instance" "jump_box" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.mcp_project_key.key_name
  vpc_security_group_ids = [aws_security_group.SG_jump.id]
  subnet_id              = aws_subnet.main-public.id
  private_ip             = var.jump_box_private_ip
  user_data = file("./templates/setup-jump.sh")

  tags = {
    Name = "Jump Box"
  }
}

output "jump_box_public_ip" {
  value = aws_instance.jump_box.public_ip
}

output "jump_box_user" {
  value = "ubuntu"  # or use a variable if needed
}


/*
All machines will use the same ssh key. In order to facilitate
the connection from your local machine, through the jump box, to the other instances,
we need a way for the jump box to authenticate. It would be suboptimal to place the
private key on the jump box itself. Instead, we can use SSH agent forwarding.

On your local machine, run:

  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/mcp_project_key

to start the SSH agent and load your private key into memory.

Then connect to the jump box with agent forwarding:

  ssh -A -i ~/.ssh/mcp_project_key ubuntu@<jump-box-public-ip>

This lets you securely SSH from the jump box into the other instance in the private subnet.
*/


#########################################################
###################  Agent Box   ########################
#########################################################



resource "aws_instance" "agent" {
  depends_on = [aws_nat_gateway.main_nat]
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.large"
  key_name               = aws_key_pair.mcp_project_key.key_name
  vpc_security_group_ids = [aws_security_group.SG_agent.id]
  subnet_id              = aws_subnet.main-private.id
  private_ip             = var.agent_private_ip

  tags = {
    Name = "Agent"
  }

  user_data = file("./templates/setup-agent.sh")
}

output "agent_private_ip" {
  value = aws_instance.agent.private_ip
}

output "agent_user" {
  value = "ubuntu"  # or use a variable if needed
}

#########################################################
#################  MCP Server Box   #####################
#########################################################


resource "aws_instance" "mcp" {
  depends_on = [aws_nat_gateway.main_nat]
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.large"
  key_name               = aws_key_pair.mcp_project_key.key_name
  vpc_security_group_ids = [aws_security_group.SG_mcp.id]
  subnet_id              = aws_subnet.main-private.id
  private_ip             = var.mcp_private_ip

  tags = {
    Name = "MCP Server"
  }

  user_data = file("./templates/setup-mcp.sh")
}

output "mcp_private_ip" {
  value = aws_instance.mcp.private_ip
}

output "mcp_user" {
  value = "ubuntu"  # or use a variable if needed
}
