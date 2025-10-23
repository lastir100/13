terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.164.0"
    }
  }

  required_version = ">=1.8.4"
}

provider "yandex" {}

