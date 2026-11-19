terraform {
  required_version = ">= 1.11.0"

  required_providers {
    nomatron = {
      source  = "nomatronio/nomatron"
      version = "~> 0.6"
    }
  }
}
