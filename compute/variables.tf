# --- compute/main.tf ---

variable "instance_count" {}
variable "instance_type" {}
variable "vol_size" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "key_name" {}
variable "public_key_path" {}
variable "user_data_path" {}
variable "dbuser" {}
variable "db_name" {}
variable "dbpassword" {}
variable "db_endpoint" {}
variable "lb_target_group_arn" {}
variable "tg_port" {}
variable "private_key_path" {}