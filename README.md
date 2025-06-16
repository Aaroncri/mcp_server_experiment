This is an AWS environment deployed in terraform for the purposes of hosting a Langflow server.

To run the script yourself, you'll need to do the following: 

1. Have terraform and AWS CLI installed on your local machine

2. To connect for testing you can do the following: 

-Run the following terraform commands: 

    terraform init 

-Run the deploy script: 
    chmod +x deploy_script.sh && ./deploy_script

-The output block in ec2_instances.tf should cause the script to output
the public IP address of the jump box, which will be used to update 
~/.ssh/config.langflow, as to 

-To connect to your servers, you can add the following to ~/.ssh/config: 

Host jump
  HostName  <jump_box_public_ip>
  User      ubuntu
  IdentityFile ~/.ssh/langflow_ssh_key
  ForwardAgent yes

Host langflow
  HostName  10.0.2.30
  User      ubuntu
  IdentityFile ~/.ssh/langflow_ssh_key
  ProxyJump jump

using the jump box IP that the script outputs. Note that as we have 
configured this, the public IP of the jump box may change when you shut 
it off and restart it! 

-To see the public IP of your instance, you can run: 

$aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].PublicIpAddress"  \
  --output text \
  --region us-east-1

in the terminal. 

-To connect to the jumpbox you can now run: 

$ssh jump

-To connect to the langlow server directly, you can run: 

$ssh langflow





