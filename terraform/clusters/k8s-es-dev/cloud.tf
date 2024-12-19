terraform {
  cloud {
    organization = "symplectic"
    workspaces {
      name    = "k8s-es-dev"
      project = "Elements Elastic Search"
    }
  }
}
