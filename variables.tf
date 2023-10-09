##############
# Basic Group
##############

# @group "Basic/Target"
# @label "Addresses"
variable "target_addresses" {
  type        = list(string)
  description = "The addresses of the target hosts to connect to. Item can be a IP[:Port] address or a DNS name."

  validation {
    condition = alltrue([
      for address in var.target_addresses :
      anytrue([
        can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", split(":", address)[0])),
        can(regex("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", split(":", address)[0]))
      ])
    ])
    error_message = "Invalid target address, must be a valid IP or DNS name."
  }
}

# @group "Basic/Target"
# @label "Authentication Type"
# @options ["SSH","WinRM"]
variable "target_authn_type" {
  type        = string
  description = "The type of authentication to use for the target host, either `SSH` or `WinRM`."
  default     = "SSH"

  validation {
    condition     = contains(["SSH", "WinRM"], var.target_authn_type)
    error_message = "Invalid target authentication type, must be one of `SSH` or `WinRM`."
  }
}

# @group "Basic/Target"
# @label "Authentication User"
variable "target_authn_user" {
  type        = string
  description = "The user to use for authenticating to the target host."
  default     = "root"

  validation {
    condition     = length(var.target_authn_user) > 0
    error_message = "Invalid target authentication user, must be at least 1 character long."
  }
}

# @group "Basic/Target"
# @label "Authentication Secret"
variable "target_authn_secret" {
  type        = string
  description = "The secret to use for authenticating to the target host. This can be a password or a private key."
  sensitive   = true

  validation {
    condition     = length(var.target_authn_secret) > 0
    error_message = "Invalid target authentication secret, must be at least 1 character long."
  }
}

# @group "Basic/Target"
# @label "Insecure"
variable "target_insecure" {
  type        = bool
  description = "Whether to skip TLS verification when connecting to the target host."
  default     = true
}

# @group "Basic/Target"
# @label "Proxies"
variable "target_proxies" {
  type = list(object({
    address      = string
    insecure     = bool
    authn_type   = string
    authn_user   = string
    authn_secret = string
  }))
  description = "The proxies to use when connecting to the target host. Item can be a bastion host or connection proxy."
  default     = []

  validation {
    condition = length(var.target_proxies) == 0 || alltrue([
      for proxy in var.target_proxies :
      alltrue([
        can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", split(":", proxy.address)[0])),
        can(regex("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", split(":", proxy.address)[0]))
      ])
    ])
    error_message = "Invalid proxy address, must be a valid IP or DNS name."
  }

  validation {
    condition = length(var.target_proxies) == 0 || alltrue([
      for proxy in var.target_proxies : contains(["SSH", "Proxy"], proxy.authn_type)
    ])
    error_message = "Invalid proxy authentication type, must be one of `SSH` or `Proxy`."
  }
}

# @group "Basic/Runtime"
# @label "Source"
variable "runtime_source" {
  type        = string
  description = "The source of runtime."
  default     = ""
}

# @group "Basic/Runtime"
# @label "Class"
# @options ["Tomcat","OpenJDK","Docker"]
variable "runtime_class" {
  type        = string
  description = "The class of runtime to be used."
}

# @group "Basic/Artifact"
# @label "Refer URI"
variable "artifact_refer_uri" {
  type        = string
  description = "The URI of the artifact to be pulled."
}

# @group "Basic/Artifact"
# @label "Refer Authentication Type"
# @options ["None","Basic","Bearer"]
variable "artifact_refer_authn_type" {
  type        = string
  description = "The type of authentication to be used for pulling the artifact."
  default     = "None"

  validation {
    condition     = length(var.artifact_refer_authn_type) > 0 && contains(["None", "Basic", "Bearer"], var.artifact_refer_authn_type)
    error_message = "Invalid artifact authentication type, must be one of `None`, `Basic` or `Bearer`."
  }
}

# @group "Basic/Artifact"
# @label "Refer Authentication User"
# @show_if "artifact_refer_authn_type=Basic"
variable "artifact_refer_authn_user" {
  type        = string
  description = "The username of the authentication to be used for pulling the artifact."
  default     = ""
}

# @group "Basic/Artifact"
# @label "Refer Authentication Secret"
# @show_if "artifact_refer_authn_type!=None"
variable "artifact_refer_authn_secret" {
  type        = string
  description = "The secret of the authentication to be used for pulling the artifact, either password or token."
  default     = ""
}

# @group "Basic/Artifact"
# @label "Refer Insecure"
variable "artifact_refer_insecure" {
  type        = bool
  description = "Whether to skip TLS verification when pulling the artifact."
  default     = true
}

# @group "Basic/Artifact"
# @label "Command"
variable "artifact_command" {
  type        = string
  description = "The command to start the artifact."
  default     = ""
}

# @group "Basic/Artifact"
# @label "Ports"
variable "artifact_ports" {
  type        = list(number)
  description = "The ports to be exposed by the artifact."
  default     = []
}

# @group "Basic/Artifact"
# @label "Environments"
variable "artifact_envs" {
  type        = map(string)
  description = "The environment variables to be set for the artifact."
  default     = {}
}

# @group "Basic/Artifact"
# @label "Volumes"
variable "artifact_volumes" {
  type        = list(string)
  description = "The volumes to be mounted for the artifact."
  default     = []
}

#################
# Advanced Group
#################

# @group "Advanced"
# @label "Deployment Strategy"
# @options ["Recreate","Rolling"]
variable "deployment_strategy" {
  type        = string
  description = "The deployment strategy to use, either `Recreate` or `Rolling`."
  default     = "Recreate"

  validation {
    condition     = contains(["Recreate", "Rolling"], var.deployment_strategy)
    error_message = "Invalid deployment strategy, must be one of `Recreate` or `Rolling`."
  }
}

# @group "Advanced"
# @label "Deployment Rolling Max Surge"
# @show_if "deployment_strategy=Rolling"
variable "deployment_strategy_rolling_max_surge" {
  type        = number
  description = "The maximum percent of targets to deploy at once during rolling."
  default     = 0.3

  validation {
    condition     = var.deployment_strategy_rolling_max_surge >= 0.1 && var.deployment_strategy_rolling_max_surge <= 1
    error_message = "Invalid deployment rolling maximum surge, must be between 0.1 and 1.0."
  }
}

# @group "Advanced"
# @label "Deployment Progress Timeout"
variable "deployment_progress_timeout" {
  type        = string
  description = "The timeout for deployment progress."
  default     = "5m"
}

###########################
# Injection Group (Hidden)
###########################

# @hidden
variable "walrus_metadata_project_name" {
  type        = string
  description = "Walrus metadata project name."
  default     = ""
}

# @hidden
variable "walrus_metadata_environment_name" {
  type        = string
  description = "Walrus metadata environment name."
  default     = ""
}

# @hidden
variable "walrus_metadata_service_name" {
  type        = string
  description = "Walrus metadata service name."
  default     = ""
}
