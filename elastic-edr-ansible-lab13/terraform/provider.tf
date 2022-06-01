terraform {
  required_version = ">= 0.12.0"
  required_providers {
    linode = {
      source = "linode/linode"
    }
    local = ">= 1.2"
  }
}
provider "linode" {
  token = var.li_token
}
terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id = true
    skip_get_ec2_platforms = true
  }
}