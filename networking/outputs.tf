# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.jessew_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.jessew_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.jessew_sg["rds"].id]
}

output "public_sg" {
  value = aws_security_group.jessew_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.jessew_public_subnet.*.id
}