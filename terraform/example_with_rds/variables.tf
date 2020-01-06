variable "region" {
  default = "eu-central-1"
}

variable "bucket_name" {
  type = string
  description = "The bucket name for saving terraform state"
}
variable "vpc_key" {
  type = string
  default = "vpc"
}
variable "env_db_pass" {
  type = string

}