variable "os_images" {
  description = "The images configured onto the hypervisors."
  type        = map(string)
  default = {
    "debian_11" = "https://cloud.debian.org/images/cloud/bullseye/20220613-1045/debian-11-genericcloud-amd64-20220613-1045.qcow2",
  }
}

variable "os_image_format" {
  description = "The format used by the images."
  type        = string
  default     = "qcow2"
}
