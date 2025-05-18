# variables for ssh connection
variable "user" {
  default = "manhlam"
  type    = string
  description = "account name to connect to the host"
}

variable "host" {
  default = "192.168.1.5"
  type    = string
  description = "value of the host to connect to"
}

variable "private_key_path" {
  type    = string
  default = "~/.ssh/id_rsa"
  description = "value of the private key path to connect to the host"
}

# variables for Kafka installation
variable "kafka_version" {
  type    = string
  default = "3.6.1"
  description = "value of the Kafka version to install"
}


# variables for PostgreSQL installation
variable "postgres_version" {
  type    = string
  default = "16"
  description = "value of the PostgreSQL version to install"
}

variable "postgres_user" {
  type    = string
  default = "postgres"
  description = "value of the PostgreSQL user to create"
}

variable "postgres_password" {
  type    = string
  default = "password"
  description = "value of the PostgreSQL password to create"
}

# variables for Redis installation
variable "redis_version" {
  type    = string
  default = "7.0.0"
  description = "value of the Redis version to install"
}

variable "redis_password" {
  type    = string
  default = "password"
  description = "value of the Redis password to create"
}