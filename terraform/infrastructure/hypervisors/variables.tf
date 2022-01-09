variable "hypervisor_hosts" {
  description = "A map of host related variables."
  type        = map(map(string))
  default     = {
    "host" = {
      "ip"   = "127.0.0.1",
      "user" = "root",
    }
  }
}

variable "os_images" {
  description = "The images configured onto the hypervisors."
  type        = map(string)
  default     = {
    "centos_7"  = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2",
    "debian_10" = "https://cloud.debian.org/images/cloud/buster/20210208-542/debian-10-genericcloud-amd64-20210208-542.qcow2",
  }
}

variable "os_image_format" {
  description = "The format used by the images."
  type        = string
  default     = "qcow2"
}
