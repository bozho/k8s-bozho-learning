provider "proxmox" {
  endpoint = "https://10.100.50.18:8006/"

#  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_USERNAME environment variable
#  username = "root@pam"
#  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_PASSWORD environment variable
#  password = "the-password-set-during-installation-of-proxmox-ve"

  # because self-signed TLS certificate is in use
  insecure = true
  # uncomment (unless on Windows...)
  # tmp_dir  = "/var/tmp"

  ssh {
#    agent = true
    username = "bozho"
  }
}



#provider "aws" {
#  # Alternatively, we could define env. variables:
#  # AWS_PROFILE
#  # or
#  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
#  profile = "internal"
#  region  = "eu-central-1"
#
#  default_tags {
#    tags = {
#      Name = local.instance_name
#    }
#  }
#}
#
#provider "aws" {
#  # Alternatively, we could define env. variables:
#  # AWS_PROFILE
#  # or
#  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
#  profile = "internal"
#  region  = "eu-central-1"
#  alias   = "route53"
#
#  assume_role {
#    role_arn     = module.globals.manage_symplectic_org_iam_role
#    session_name = "route53"
#  }
#
#  default_tags {
#    tags = {
#      Name = local.instance_name
#    }
#  }
#}
