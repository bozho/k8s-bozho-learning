module proxmox {
  source = "../../modules/proxmox-k8s"
}



#module "globals" {
#  source  = "app.terraform.io/symplectic/globals/symplectic"
#  version = "~> 1.3.0"
#}
#
## Fetch default tags passed in from the root module.
#data "aws_default_tags" "mirror" {}
#
## We need AWS account ID in several places. Fetch it here.
#data "aws_caller_identity" "account" {}
#
#################################################################################
## Validate inputs
#################################################################################
#
#resource "null_resource" "validate_default_tags_name" {
#  lifecycle {
#    precondition {
#      condition = lookup(data.aws_default_tags.mirror.tags, "Name", null) != null
#      error_message = "Default tags must contain the 'Name' tag."
#    }
#  }
#}
#
#resource "null_resource" "validate_subnet_extension" {
#  lifecycle {
#    precondition {
#      condition = can(cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, 0))
#      error_message = "Insufficient address space to extend VPC CIDR ${var.vpc_cidr} prefix by ${var.vpc_subnet_bits}."
#    }
#  }
#}
#
#################################################################################

output "proxmox" {
  value = module.proxmox
  
}