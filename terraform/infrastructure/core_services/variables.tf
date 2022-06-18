variable "domain" {
  description = "The domain that forms the FQDN."
  type        = string
}

variable "network_gateway_ip" {
  description = "A string of the network's gateway IP."
  type        = string
}

variable "network_nameserver_ips" {
  description = "A comma seperated string of nameserver IPs."
  type        = string
  default     = "127.0.0.1, 127.0.0.2"
}
