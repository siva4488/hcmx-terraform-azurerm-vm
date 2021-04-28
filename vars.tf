variable "subscription_id" {
  }
variable "client_id" {
  }
variable "tenant_id" {
  }
variable "client_secret" {
  }
variable "password" {
  }
variable "admin" {
  description = "Default user with root access"
 # type = "map"
  default = {
    name = "terraform"
    public_key = ""
  }
}

variable "namespace" {
  description = "Prefix for resource names"
}
variable "name" {
  description = "Name of the service"
}
variable "location" {
  description = "Resource location. To see full list run 'az account list-locations'"
}
variable "cidr" {
  default = "10.0.0.0/16"
}
variable "subnet" {
  default = "10.0.1.0/24"
}
variable "vm_size" {
  description = "Size of the vm. To see full list run 'az vm list-sizes'"
}
variable "vm_disk_type" {
  description = "Storage class. Can be Standard_LRS or Premium_LRS"
  default = "Standard_LRS"
}
variable "allocation_method" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  default     = "Dynamic"
}
variable "os" {
  description = "Disk image with preinstalled OS"
 # type = "map"
  default = {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.4"
    os_version = "latest"
  }
}

variable "publisher" {
  description = "The Publisher"
  }

variable "username" {
  description = "The username for the target VM"
  }

variable "os_version" {
  description = "The version"
  }

variable "tag1" {
  }

variable "offer" {
  }

variable "sku" {
  }

variable "os_version" {
  }
