module "tgw" {
  source = "../../.."

  name                                  = "test-tgw"
  description                           = "My TGW shared with several other AWS accounts"
  amazon_side_asn                       = 64532
  transit_gateway_cidr_blocks           = ["10.0.10.0/24"]
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {
    account1_vpc_main = {
      vpc_id      = module.vpc_main.vpc.id
      subnet_ids  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_main.subnets["protected_${subnet_name}"].id]
      dns_support = true

      tags = {
        Name = "account1_vpc_main"
      }
    },
    account1_vpc_secondary = {
      vpc_id      = module.vpc_secondary.vpc.id
      subnet_ids  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_secondary.subnets["protected_${subnet_name}"].id]
      dns_support = true

      tags = {
        Name = "account1_vpc_secondary"
      }
    },
  }

  share_tgw                     = true
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "test-tgw"
    Environment = "test"
  }
}
