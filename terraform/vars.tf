# CIDR Blocks
variable "main_vpc_cidr_block" {
  description = "CIDR block for the main environment VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet in the private environment"
  type        = string
  default     = "10.0.2.0/24"
}

variable "jump_box_private_ip" {
  description = "Hard-coded IP for jump box"
  type        = string
  default     = "10.0.1.30"
}

variable "agent_private_ip" {
  description = "Hard-coded IP for agent instance"
  type        = string
  default     = "10.0.2.30"
}

variable "mcp_server_private_ip" {
  description = "Hard-coded IP for mcp_server instance"
  type        = string
  default     = "10.0.2.31"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "mcp_project_key"
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/mcp_project_key.pub"
}
