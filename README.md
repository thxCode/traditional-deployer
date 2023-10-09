# Traditional Deployer

This module delivers traditional deployments.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_courier"></a> [courier](#requirement\_courier) | >= 0.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_courier"></a> [courier](#provider\_courier) | >= 0.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [courier_deployment.deployment](https://registry.terraform.io/providers/seal-io/courier/latest/docs/resources/deployment) | resource |
| [courier_artifact.artifact](https://registry.terraform.io/providers/seal-io/courier/latest/docs/data-sources/artifact) | data source |
| [courier_runtime.runtime](https://registry.terraform.io/providers/seal-io/courier/latest/docs/data-sources/runtime) | data source |
| [courier_target.targets](https://registry.terraform.io/providers/seal-io/courier/latest/docs/data-sources/target) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_command"></a> [artifact\_command](#input\_artifact\_command) | The command to start the artifact. | `string` | `""` | no |
| <a name="input_artifact_envs"></a> [artifact\_envs](#input\_artifact\_envs) | The environment variables to be set for the artifact. | `map(string)` | `{}` | no |
| <a name="input_artifact_ports"></a> [artifact\_ports](#input\_artifact\_ports) | The ports to be exposed by the artifact. | `list(number)` | `[]` | no |
| <a name="input_artifact_refer_authn_secret"></a> [artifact\_refer\_authn\_secret](#input\_artifact\_refer\_authn\_secret) | The secret of the authentication to be used for pulling the artifact, either password or token. | `string` | `""` | no |
| <a name="input_artifact_refer_authn_type"></a> [artifact\_refer\_authn\_type](#input\_artifact\_refer\_authn\_type) | The type of authentication to be used for pulling the artifact. | `string` | `"None"` | no |
| <a name="input_artifact_refer_authn_user"></a> [artifact\_refer\_authn\_user](#input\_artifact\_refer\_authn\_user) | The username of the authentication to be used for pulling the artifact. | `string` | `""` | no |
| <a name="input_artifact_refer_insecure"></a> [artifact\_refer\_insecure](#input\_artifact\_refer\_insecure) | Whether to skip TLS verification when pulling the artifact. | `bool` | `true` | no |
| <a name="input_artifact_refer_uri"></a> [artifact\_refer\_uri](#input\_artifact\_refer\_uri) | The URI of the artifact to be pulled. | `string` | n/a | yes |
| <a name="input_artifact_volumes"></a> [artifact\_volumes](#input\_artifact\_volumes) | The volumes to be mounted for the artifact. | `list(string)` | `[]` | no |
| <a name="input_deployment_progress_timeout"></a> [deployment\_progress\_timeout](#input\_deployment\_progress\_timeout) | The timeout for deployment progress. | `string` | `"5m"` | no |
| <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy) | The deployment strategy to use, either `Recreate` or `Rolling`. | `string` | `"Recreate"` | no |
| <a name="input_deployment_strategy_rolling_max_surge"></a> [deployment\_strategy\_rolling\_max\_surge](#input\_deployment\_strategy\_rolling\_max\_surge) | The maximum percent of targets to deploy at once during rolling. | `number` | `0.3` | no |
| <a name="input_runtime_class"></a> [runtime\_class](#input\_runtime\_class) | The class of runtime to be used. | `string` | n/a | yes |
| <a name="input_runtime_source"></a> [runtime\_source](#input\_runtime\_source) | The source of runtime. | `string` | `""` | no |
| <a name="input_target_addresses"></a> [target\_addresses](#input\_target\_addresses) | The addresses of the target hosts to connect to. Item can be a IP[:Port] address or a DNS name. | `list(string)` | n/a | yes |
| <a name="input_target_authn_secret"></a> [target\_authn\_secret](#input\_target\_authn\_secret) | The secret to use for authenticating to the target host. This can be a password or a private key. | `string` | n/a | yes |
| <a name="input_target_authn_type"></a> [target\_authn\_type](#input\_target\_authn\_type) | The type of authentication to use for the target host, either `SSH` or `WinRM`. | `string` | `"SSH"` | no |
| <a name="input_target_authn_user"></a> [target\_authn\_user](#input\_target\_authn\_user) | The user to use for authenticating to the target host. | `string` | `"root"` | no |
| <a name="input_target_insecure"></a> [target\_insecure](#input\_target\_insecure) | Whether to skip TLS verification when connecting to the target host. | `bool` | `true` | no |
| <a name="input_target_proxies"></a> [target\_proxies](#input\_target\_proxies) | The proxies to use when connecting to the target host. Item can be a bastion host or connection proxy. | <pre>list(object({<br>    address      = string<br>    insecure     = bool<br>    authn_type   = string<br>    authn_user   = string<br>    authn_secret = string<br>  }))</pre> | `[]` | no |
| <a name="input_walrus_metadata_environment_name"></a> [walrus\_metadata\_environment\_name](#input\_walrus\_metadata\_environment\_name) | Walrus metadata environment name. | `string` | `""` | no |
| <a name="input_walrus_metadata_project_name"></a> [walrus\_metadata\_project\_name](#input\_walrus\_metadata\_project\_name) | Walrus metadata project name. | `string` | `""` | no |
| <a name="input_walrus_metadata_service_name"></a> [walrus\_metadata\_service\_name](#input\_walrus\_metadata\_service\_name) | Walrus metadata service name. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_access"></a> [endpoint\_access](#output\_endpoint\_access) | The endpoint to access. |
<!-- END_TF_DOCS -->
