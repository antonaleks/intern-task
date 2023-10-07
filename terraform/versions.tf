# Инициализация Terraform и хранения Terraform State
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.49.0"
    }
  }

  backend "local" {
    path = "./skril.tfstate"
  }

  # backend "s3" {
  #   bucket                      = "/students"
  #   endpoint                    = "s3.storage.selcloud.ru"
  #   key                         = "skril.tfstate"
  #   region                      = "ru-1"
  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   access_key                  = var.access_key
  #   secret_key                  = var.secret_key
  # }

  # backend "s3" {
  #   bucket = "/students"
  #   # endpoint {
  #   #   s3 = "http://s3.ru-1.storage.selcloud.ru"
  #   # }
  #   endpoint-url                = "https://s3.storage.selcloud.ru"
  #   key                         = "skril.tfstate" # название стейта указать <фамилия>.tfstate
  #   region                      = "ru-1"
  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   # access_key = var.access_key
  #   # secret_key = var.secret_key
  # }
}
