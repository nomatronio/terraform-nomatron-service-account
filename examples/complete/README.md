# Complete example

This example creates a service account, assigns the `release-manager` role globally and in one organization, and mints an ephemeral token. The organization ID is a clearly fake UUID; replace it with an existing organization UUID before applying.

Set `TF_VAR_nomatron_address` and `TF_VAR_nomatron_token` in the environment. The child module's token output is ephemeral; pass it directly to a secret store's write-only argument in this same apply. This example does not re-export the token from its root outputs. Do not print or save the token in state.

The commented `example_secret` resource in `main.tf` illustrates the same-apply pattern. Replace it with the secret store resource used by your configuration.
