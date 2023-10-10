terraform {
  required_version = ">= 1.0"

  required_providers {
    courier = {
      source = "seal-io/courier"
    }
    multipass = {
      source  = "larstobi/multipass"
    }
  }
}

provider "multipass" {}

provider "courier" {}

variable "instances" {
  type    = number
  default = 1
}

data "multipass_instance" "example" {
  count = var.instances

  name = format("courier-%d", count.index)

  lifecycle {
    postcondition {
      condition     = self.state == "Running"
      error_message = "Invaild multipass instance, ${self.name} is not running"
    }
  }
}

module "deployer" {
  source = "../../"

  target_addresses     = data.multipass_instance.example.*.ipv4
  target_authn_type    = "SSH"
  target_authn_user    = "ansible"
  target_authn_secret  = "ansible"

  runtime_source   = "https://github.com/seal-io/terraform-provider-courier//pkg/runtime/source_builtin"
  runtime_class    = "Tomcat"

  artifact_refer_uri = "https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war"
  artifact_ports     = [80]

  deployment_strategy                   = "Rolling"
  deployment_strategy_rolling_max_surge = 0.5

  walrus_metadata_service_name = "example"
}

output "endpoint" {
  value = module.deployer.endpoint_access
}