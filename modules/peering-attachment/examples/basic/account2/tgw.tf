module "tgw_region1" {
  providers = {
    aws = aws.region1
  }

  source = "../../../../.."

  name                                  = "dev-tgw-region1"
  description                           = "My TGW shared with several other AWS accounts in us-west-2 region"
  amazon_side_asn                       = 64532
  create_tgw                            = false
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {
    account2_vpc_region1 = {
      tgw_id     = local.account1_tgw_ids.region1
      vpc_id     = module.vpc_region1.vpc.id
      subnet_ids = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region1.subnets["protected_${subnet_name}"].id]

      tags = {
        Name = "account2_vpc_region1"
      }
    },
  }

  share_tgw                     = false
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "dev-tgw-region1"
    Environment = "dev"
  }
}

module "tgw_region2" {
  providers = {
    aws = aws.region2
  }

  source = "../../../../.."

  name                                  = "dev-tgw-region2"
  description                           = "My TGW shared with several other AWS accounts in us-east-2 region"
  amazon_side_asn                       = 64532
  create_tgw                            = false
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {
    account2_vpc_region2 = {
      tgw_id     = local.account1_tgw_ids.region2
      vpc_id     = module.vpc_region2.vpc.id
      subnet_ids = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region2.subnets["protected_${subnet_name}"].id]

      tags = {
        Name = "account2_vpc_region2"
      }
    },
  }

  share_tgw                     = false
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "dev-tgw-region2"
    Environment = "dev"
  }
}
