
# VPC variable
variable "main_vpc_cidr" {
  type        = string
  description = "Main VPC CIDR value"
}
variable "public_subnet_a" {
  type        = string
  description = "CIDR value for public subnet a"
}
variable "private_subnet_a" {
  type        = string
  description = "CIDR value for private subnet a"
}
variable "public_subnet_b" {
  type        = string
  description = "CIDR value for public subnet b"
}
variable "private_subnet_b" {
  type        = string
  description = "CIDR value for private subnet b"
}
variable "dns_support" {
  type        = bool
  description = "Bool value for VPC DNS support"
}
variable "dns_hostnames" {
  type        = bool
  description = "Bool value for VPC DNS hostnames"
}
variable "state" {
  type        = string
  description = "State value for availability zone"
}
variable "service" {
  type        = string
  description = "Name of the project"
}
