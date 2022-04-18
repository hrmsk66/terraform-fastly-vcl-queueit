variable "domain" {
  type = string
}

variable "service_name" {
  type = string
}

variable "dns_zone" {
  type = string
}

variable "config" {
  type = object({ name = string, items = map(string) })
}

variable "routing" {
  type = object({ name = string, items = map(string) })
}