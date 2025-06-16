# CIDR Blocks
variable "main_vpc_cidr_block" {
  description = "CIDR block for the main environment VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_langflow_subnet_cidr_block" {
  description = "CIDR block for the public subnet in the Langflow environment"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_langflow_subnet_cidr_block" {
  description = "CIDR block for the private subnet in the Langflow environment"
  type        = string
  default     = "10.0.2.0/24"
}

variable "jump_box_private_ip" {
  description = "Hard-coded IP for jump box"
  type        = string
  default     = "10.0.1.30"
}

variable "langflow_private_ip" {
  description = "Hard-coded IP for Langflow instance"
  type        = string
  default     = "10.0.2.30"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "langflow_ssh_key"
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/langflow_ssh_key.pub"
}
