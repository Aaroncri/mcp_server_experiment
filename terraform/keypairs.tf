
/*
We can create an aws_key_pair object by locally generating keys with openssh
and using the resulting pubkey to generate an aws_key_pair resource. Here, I used
the command: 

ssh-keygen -t rsa -b 4096 -f ~/.ssh/mcp_project_key

on my local Linux box to create the key pair. 
*/

resource "aws_key_pair" "mcp_project_key" {
  key_name   = "mcp_project_key"
  # Change this line:
  public_key = file(var.public_key_path) # <-- Use the variable here
}