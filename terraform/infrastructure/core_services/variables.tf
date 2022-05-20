variable "hypervisor_hosts" {
  description = "A map of host related variables."
  type        = map(map(string))
  default = {
    "host" = {
      "ip"   = "127.0.0.1",
      "user" = "root",
    }
  }
}

variable "virtual_machines" {
  description = "A map of virtual machine related variables."
  type        = map(map(string))
  default = {
    "vm1" = {
      "ip" = "127.0.0.1",
      "os" = "debian_10",
    }
  }
}

variable "domain" {
  description = "The domain that forms the FQDN."
  type        = string
}

variable "host_admin_users" {
  description = "A map of admin users to configure with their SSH Key."
  type        = map(string)
  default = {
    "admin" = "ssh-rsa AA[...]ZZ==",
  }
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
