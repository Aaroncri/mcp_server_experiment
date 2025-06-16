#########################################################
###############      Jump Box       #####################
#########################################################

resource "aws_instance" "jump_box" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.jump_box_key.key_name
  vpc_security_group_ids = [aws_security_group.SG_jump.id]
  subnet_id              = aws_subnet.main-public.id
  private_ip             = var.jump_box_private_ip

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

#########################################################
######  Langflow Box (for Jump Box connection)  ########
#########################################################

/*
The Langflow instance will use the same SSH key as the jump box. In order to facilitate
the connection from your local machine, through the jump box, to the Langflow instance,
we need a way for the jump box to authenticate. It would be suboptimal to place the
private key on the jump box itself. Instead, we can use SSH agent forwarding.

On your local machine, run:

  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/netsec_jump_box_key

to start the SSH agent and load your private key into memory.

Then connect to the jump box with agent forwarding:

  ssh -A -i ~/.ssh/netsec_jump_box_key ubuntu@<jump-box-public-ip>

This lets you securely SSH from the jump box into the Langflow instance in the private subnet.
*/


resource "aws_instance" "langflow" {
  depends_on = [aws_nat_gateway.langflow_nat]
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.large"
  key_name               = aws_key_pair.jump_box_key.key_name
  vpc_security_group_ids = [aws_security_group.SG_langflow.id]
  subnet_id              = aws_subnet.main-private.id
  private_ip             = var.langflow_private_ip

  tags = {
    Name = "Langflow"
  }

  user_data = file("./scripts/setup-langflow.sh")
}

output "langflow_private_ip" {
  value = aws_instance.langflow.private_ip
}

output "langflow_user" {
  value = "ubuntu"  # or use a variable if needed
}