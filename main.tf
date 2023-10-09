locals {
  target_addresses = sort(distinct(var.target_addresses))
  artifact_ports   = try(sort(distinct(var.artifact_ports)), null)
}

data "courier_target" "targets" {
  count = length(local.target_addresses)

  host = {
    address = local.target_addresses[count.index]
    authn   = {
      type   = lower(var.target_authn_type)
      user   = var.target_authn_user
      secret = var.target_authn_secret
    }
    insecure = var.target_insecure
    proxies  = length(var.target_proxies) > 0 ? [
      for proxy in var.target_proxies : {
        address = proxy.address
        authn   = {
          type   = lower(proxy.authn_type)
          user   = proxy.authn_user
          secret = proxy.authn_secret
        }
        insecure = proxy.insecure
      }
    ] : null
  }

  timeouts = {
    create = "5m"
    update = "5m"
  }
}

data "courier_artifact" "artifact" {
  refer = {
    uri   = var.artifact_refer_uri
    authn = var.artifact_refer_authn_type != "None" ? {
      type   = lower(var.artifact_refer_authn_type)
      user   = var.artifact_refer_authn_user
      secret = var.artifact_refer_authn_secret
    } : null
    insecure = var.artifact_refer_insecure
  }

  command = var.artifact_command
  ports   = local.artifact_ports
  envs    = var.artifact_envs
  volumes = var.artifact_volumes

  timeouts = {
    create = "5m"
    update = "5m"
  }
}

data "courier_runtime" "runtime" {
  source = var.runtime_source
  class  = lower(var.runtime_class)
}

resource "courier_deployment" "deployment" {
  targets  = data.courier_target.targets
  artifact = data.courier_artifact.artifact
  runtime  = data.courier_runtime.runtime

  strategy = {
    type    = lower(var.deployment_strategy)
    rolling = var.deployment_strategy == "Rolling" ? {
      max_surge = var.deployment_strategy_rolling_max_surge
    } : null
  }

  timeouts = {
    create = var.deployment_progress_timeout
    update = var.deployment_progress_timeout
    delete = var.deployment_progress_timeout
  }
}

locals {
  endpoints = try(flatten(
    [ for port in local.artifact_ports : formatlist("%s:%v", local.target_addresses, port) ]
  ), null)
}
