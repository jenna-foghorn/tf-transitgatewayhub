module "tgw_region1" {
  providers = {
    aws = aws.region1
  }

  source = "../../../../.."

  name                                  = "test-tgw-region1"
  description                           = "My TGW shared with several other AWS accounts in us-west-2 region"
  amazon_side_asn                       = 64532
  transit_gateway_cidr_blocks           = []
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {
    account1_vpc_region1 = {
      vpc_id     = module.vpc_region1.vpc.id
      subnet_ids = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region1.subnets["protected_${subnet_name}"].id]

      tags = {
        Name = "account1_vpc_region1"
      }
    },
  }

  share_tgw                     = true
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "test-tgw-region1"
    Environment = "test"
  }
}

module "tgw_region2" {
  providers = {
    aws = aws.region2
  }

  source = "../../../../.."

  name                                  = "test-tgw-region2"
  description                           = "My TGW shared with several other AWS accounts in us-east-2 region"
  amazon_side_asn                       = 64532
  transit_gateway_cidr_blocks           = []
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {
    account1_vpc_region2 = {
      vpc_id     = module.vpc_region2.vpc.id
      subnet_ids = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region2.subnets["protected_${subnet_name}"].id]

      tags = {
        Name = "account1_vpc_region2"
      }
    },
  }

  share_tgw                     = true
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "test-tgw-region2"
    Environment = "test"
  }
}

module "tgw_region1_peering_region2" {
  providers = {
    aws.requester = aws.region1
    aws.accepter  = aws.region2
  }

  source = "../../.."

  requester_tgw_id                   = module.tgw_region1.ec2_transit_gateway_id
  requester_tgw_route_table_id       = module.tgw_region1.ec2_transit_gateway_propagation_default_route_table_id
  requester_tgw_peering_routes_cidrs = concat([local.vpc_cidrs.region1], local.external_accounts_vpc_cidrs.region1)
  accepter_tgw_id                    = module.tgw_region2.ec2_transit_gateway_id
  accepter_tgw_route_table_id        = module.tgw_region2.ec2_transit_gateway_propagation_default_route_table_id
  accepter_tgw_peering_routes_cidrs  = concat([local.vpc_cidrs.region2], local.external_accounts_vpc_cidrs.region2)

  tag_map = {
    Name        = "test-tgw-peering-r1-r2"
    Environment = "test"
  }
}
