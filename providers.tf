provider "azurerm" {
  version = "~> 2.0"
  features {}
}

provider "kubernetes" {
  version = "1.10"
}

provider "helm" {
  version = "1.0"
}
