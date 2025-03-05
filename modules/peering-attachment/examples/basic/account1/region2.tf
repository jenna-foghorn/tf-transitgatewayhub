module "vpc_region2" {
  providers = {
    aws = aws.region2
  }

  source = "git@github.com:BuildingLink/TF-VPC?ref=v3.0.2"

  cidr_block               = local.vpc_cidrs.region2
  nat_gateway_subnet_layer = "protected"
  subnet_layers            = var.subnet_layers

  tag_map = {
    Name        = "region2"
    Environment = "test-region2"
  }
}

module "fw_region2" {
  providers = {
    aws = aws.region2
  }

  source = "git@github.com:BuildingLink/TF-FW?ref=v1.0.1"

  environment = "test-region2"
  subnets     = { for subnet_name, subnet_data in var.subnet_layers.firewall.subnets : subnet_name => module.vpc_region2.subnets["firewall_${subnet_name}"].id }
}

module "firewall_protected_routes_region2" {
  providers = {
    aws = aws.region2
  }

  for_each = var.subnet_layers.protected.subnets

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.2"

  destination    = "0.0.0.0/0"
  resource_id    = local.vpce_by_az_map_region2[module.vpc_region2.subnets["protected_${each.key}"].availability_zone]
  route_table_id = module.vpc_region2.route_tables["protected_${each.key}"].id
  target         = "vpce"
}

module "igw_protected_ingress_routes_region2" {
  providers = {
    aws = aws.region2
  }

  for_each = var.subnet_layers.protected.subnets

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.2"

  destination    = module.vpc_region2.subnets["protected_${each.key}"].cidr_block
  resource_id    = local.vpce_by_az_map_region2[module.vpc_region2.subnets["protected_${each.key}"].availability_zone]
  route_table_id = module.vpc_region2.internet_gateway_route_table.id
  target         = "vpce"
}

module "tgw_subnet_routes_region2" {
  providers = {
    aws = aws.region2
  }

  for_each = local.tgw_subnet_routes_region2_map

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.2"

  destination    = each.value.cidr
  resource_id    = module.tgw_region2.ec2_transit_gateway_id
  route_table_id = each.value.route_table_id
  target         = "tgw"
}
