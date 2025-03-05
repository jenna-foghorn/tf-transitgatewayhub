module "tgw" {
  source = "../../.."

  name                                  = "dev-tgw"
  description                           = "My TGW shared with several other AWS accounts"
  amazon_side_asn                       = 64532
  create_tgw                            = false
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {
    account2_vpc_main = {
      tgw_id      = local.account1_tgw_id
      vpc_id      = module.vpc_main.vpc.id
      subnet_ids  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_main.subnets["protected_${subnet_name}"].id]
      dns_support = true

      tags = {
        Name = "account2_vpc_main"
      }
    },
    account2_vpc_secondary = {
      tgw_id      = local.account1_tgw_id
      vpc_id      = module.vpc_secondary.vpc.id
      subnet_ids  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_secondary.subnets["protected_${subnet_name}"].id]
      dns_support = true

      tags = {
        Name = "account2_vpc_secondary"
      }
    },
  }

  share_tgw                     = false
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "dev-tgw"
    Environment = "dev"
  }
}
