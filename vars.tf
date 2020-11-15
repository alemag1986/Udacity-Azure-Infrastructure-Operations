variable "prefix" {
  type        = string
  description = "name of the project"
  default     = "udacityproj"
}
variable "location" {
  type        = string
  description = "location of resources"
  default     = "East US 2"
}
variable "vmcount" {
    type        = number
    description = "number of virtual machines"
    default     = 2
    validation {
      condition     = var.vmcount <= 5
      error_message = "The default value for the count parameter should be at least 2, and for cost reasons, no more than 5."
   }
}
variable "vmimagerg" {
    type        = string
    description = "resource group name of vm image"
    default     = "images-rg"
}
variable "vmimagename" {
    type        = string
    description = "name of the vm image"
    default     = "ubuntu-udacity-project"
}
variable "vmadmin" {
    type        = string
    description = "vm admin user"
    default     = "manager"
}
variable "vmpassword" {
    type        = string
    description = "vm admin password"
    default     = "P@ssword1!"
}
variable "vmsize" {
    type        = string
    description = "sku of vms"
    default     = "Standard_F2"
}