terraform {
  required_version = ">= 1.0"

  required_providers {
    multipass = {
      source  = "larstobi/multipass"
    }
  }
}

provider "multipass" {}

variable "instances" {
  type    = number
  default = 1
}

resource "multipass_instance" "example" {
  count = var.instances

  name           = format("courier-%d", count.index)
  memory         = "512M"
  cloudinit_file = abspath("./config/cloud-init.yaml")
}

data "multipass_instance" "example" {
  count = var.instances

  name = format("courier-%d", count.index)

  depends_on = [
    multipass_instance.example
  ]
}

output "endpoint" {
  value = data.multipass_instance.example.*.ipv4
}
