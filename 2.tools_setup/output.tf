output cluster_oidc_issuer_url {
  value = data.terraform_remote_state.remote.outputs.cluster_oidc_issuer_url
}

output oidc_provider {
  value = data.terraform_remote_state.remote.outputs.oidc_provider
}

output oidc_provider_arn {
  value = data.terraform_remote_state.remote.outputs.oidc_provider_arn
}
