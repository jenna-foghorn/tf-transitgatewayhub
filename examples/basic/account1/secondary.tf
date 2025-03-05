module "vpc_secondary" {
  source = "git@github.com:BuildingLink/TF-VPC?ref=v3.0.1"

  cidr_block               = "10.2.0.0/16"
  nat_gateway_subnet_layer = "protected"
  subnet_layers            = var.subnet_layers

  tag_map = {
    Name        = "secondary"
    Environment = "test-secondary"
  }
}

module "fw_secondary" {
  source = "git@github.com:BuildingLink/TF-FW?ref=v1.0.0"

  environment = "test-secondary"
  subnets     = { for subnet_name, subnet_data in var.subnet_layers.firewall.subnets : subnet_name => module.vpc_secondary.subnets["firewall_${subnet_name}"].id }
}

module "firewall_protected_routes_secondary" {
  for_each = var.subnet_layers.protected.subnets

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.1"

  destination    = "0.0.0.0/0"
  resource_id    = local.vpce_by_az_map_secondary[module.vpc_secondary.subnets["protected_${each.key}"].availability_zone]
  route_table_id = module.vpc_secondary.route_tables["protected_${each.key}"].id
  target         = "vpce"
}

module "igw_protected_ingress_routes_secondary" {
  for_each = var.subnet_layers.protected.subnets

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.1"

  destination    = module.vpc_secondary.subnets["protected_${each.key}"].cidr_block
  resource_id    = local.vpce_by_az_map_secondary[module.vpc_secondary.subnets["protected_${each.key}"].availability_zone]
  route_table_id = module.vpc_secondary.internet_gateway_route_table.id
  target         = "vpce"
}

module "tgw_routes_secondary" {
  for_each = local.tgw_routes_secondary_map

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.1"

  destination    = each.value.cidr
  resource_id    = module.tgw.ec2_transit_gateway_id
  route_table_id = each.value.route_table_id
  target         = "tgw"
}
