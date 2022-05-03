# --- database/variables.tf ---

variable "db_storage" {}
variable "db_instance_class" {}
variable "db_name" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "vpc_security_group_ids" {}
variable "db_subnet_group_name" {}
variable "db_engine_version" {}
variable "db_identifier" {}
variable "skip_final_snapshot" {}