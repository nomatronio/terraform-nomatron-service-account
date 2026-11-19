# Nomatron service account Terraform module

This module creates one Nomatron service account, optionally assigns roles to that service account, and can mint an ephemeral service account token for a secret store in the same apply.

## Requirements

| Name | Version |
| --- | --- |
| Terraform | `>= 1.11.0` |
| nomatron provider | `~> 0.6` |

## Usage

```hcl
module "ci_deployer" {
  source = "nomatronio/service-account/nomatron"

  name        = "ci-deployer"
  description = "CI deployment identity"

  assignments = [
    {
      role   = "release-manager"
      domain = "global"
    },
    {
      role            = "release-manager"
      organization_id = "11111111-1111-1111-1111-111111111111"
    }
  ]

  mint_token       = true
  token_name       = "ci-deployer-prod"
  token_expires_at = "2027-03-31T23:59:59Z"
}

# Illustrative only. Replace with the secret store used by your configuration.
# resource "example_secret" "ci_token" {
#   name             = "nomatron-ci-deployer-token"
#   value_wo         = module.ci_deployer.token
#   value_wo_version = module.ci_deployer.token_id
# }
```

Configure the root `nomatron` provider with your API address and a token supplied through a secure environment variable such as `TF_VAR_nomatron_token`. Do not place secrets in command-line flags or committed files.

The module sets role assignment subjects to `service_account:<id>`. Assignment domains must be `global` or `org:<uuid>`. You can provide an organization UUID with `organization_id`; the module adds the `org:` prefix. The module rejects duplicate role/domain pairs and invalid assignment domains before calling the provider.

The service account token is ephemeral and is not stored in Terraform state. Pass it directly to a secret store's write-only attribute during the same apply. If `mint_token` is false, the ephemeral outputs are null.

## Scope and behavior

- Role assignments created here apply only to this service account. The module does not assign roles to users or Nomatron groups.
- Service accounts cannot approve deployments.
- The provider's `nomatron_role_assignment` Read operation does not refresh remote assignments. Changes made outside Terraform are not detected, so keep assignment changes in Terraform.
- The `nomatron_service_account` resource supports import by UUID. Import role assignments with their composite query-string ID.
- This module does not create users or organizations. Use existing service account role names and organization IDs.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | — | Required service account name. |
| `description` | `string` | `null` | Optional service account description. |
| `is_active` | `bool` | `null` | Optional active status. When omitted, the provider/API supplies the value. |
| `assignments` | `list(object({ role = string, domain = optional(string), organization_id = optional(string) }))` | `[]` | Role assignments for this service account. Set exactly one of `domain` and `organization_id`. |
| `mint_token` | `bool` | `false` | Whether to mint an ephemeral token. |
| `token_name` | `string` | `null` | Optional display name for the minted token. |
| `token_expires_at` | `string` | `null` | Optional RFC3339 expiration timestamp. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Service account ID. |
| `name` | Service account name. |
| `is_active` | Active status reported by the provider. |
| `assignment_ids` | Composite role-assignment IDs keyed by role and domain. |
| `token` | Sensitive ephemeral raw token; pass it to a secret store in the same apply. |
| `token_id` | Ephemeral token ID, useful as a secret version. |
| `token_prefix` | Ephemeral token prefix. |

## Import

Import a service account by its UUID:

```shell
terraform import module.ci_deployer.nomatron_service_account.this 11111111-1111-1111-1111-111111111111
```

Role assignment import IDs use the subject, role, and domain query parameters:

```shell
terraform import 'module.ci_deployer.nomatron_role_assignment.this["release-manager:org:11111111-1111-1111-1111-111111111111"]' 'subject=service_account:11111111-1111-1111-1111-111111111111&role=release-manager&domain=org:11111111-1111-1111-1111-111111111111'
```

## Examples

- [`examples/basic`](examples/basic) creates a service account without assignments or a token.
- [`examples/complete`](examples/complete) demonstrates global and organization-scoped assignments and an ephemeral token handoff.

Validate an example from its directory, where this module is called as a child module. For example:

```shell
terraform -chdir=examples/basic init -backend=false
terraform -chdir=examples/basic validate
```

Terraform only permits ephemeral outputs in child modules; validating this reusable module directly from its repository root reports `Ephemeral outputs are not allowed in context of a root module`.

The mock tests use a small parent-module harness. Run them from the harness directory:

```shell
terraform -chdir=tests/harness init -backend=false
terraform -chdir=tests/harness test
```

The license will be added before publication.
