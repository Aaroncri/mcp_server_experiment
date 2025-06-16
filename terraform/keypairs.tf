
/*
We can create an aws_key_pair object by locally generating keys with openssh
and using the resulting pubkey to generate an aws_key_pair resource. Here, I used
the command: 

ssh-keygen -t rsa -b 4096 -f ~/.ssh/langflow_ssh_key

on my local Linux box to create the key pair. 
*/

resource "aws_key_pair" "jump_box_key" {
  key_name   = "jump_box_key"
  public_key = file("~/.ssh/langflow_ssh_key.pub")
}
