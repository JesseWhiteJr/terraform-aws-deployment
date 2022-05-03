terraform {
  cloud {
    organization = "jessew-terraform"

    workspaces {
      name = "jessew-dev"
    }
  }
}