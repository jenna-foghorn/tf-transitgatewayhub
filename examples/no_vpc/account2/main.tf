module "vpc_main" {
  source = "git@github.com:BuildingLink/TF-VPC?ref=v3.0.1"

  cidr_block               = "10.3.0.0/16"
  nat_gateway_subnet_layer = "protected"
  subnet_layers            = var.subnet_layers

  tag_map = {
    Name        = "main"
    Environment = "dev-main"
  }
}

module "fw_main" {
  source = "git@github.com:BuildingLink/TF-FW?ref=v1.0.0"

  environment = "dev-main"
  subnets     = { for subnet_name, subnet_data in var.subnet_layers.firewall.subnets : subnet_name => module.vpc_main.subnets["firewall_${subnet_name}"].id }
}

module "firewall_protected_routes_main" {
  for_each = var.subnet_layers.protected.subnets

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.1"

  destination    = "0.0.0.0/0"
  resource_id    = local.vpce_by_az_map_main[module.vpc_main.subnets["protected_${each.key}"].availability_zone]
  route_table_id = module.vpc_main.route_tables["protected_${each.key}"].id
  target         = "vpce"
}

module "igw_protected_ingress_routes_main" {
  for_each = var.subnet_layers.protected.subnets

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.1"

  destination    = module.vpc_main.subnets["protected_${each.key}"].cidr_block
  resource_id    = local.vpce_by_az_map_main[module.vpc_main.subnets["protected_${each.key}"].availability_zone]
  route_table_id = module.vpc_main.internet_gateway_route_table.id
  target         = "vpce"
}

module "tgw_routes_main" {
  for_each = local.tgw_routes_main_map

  source = "git@github.com:BuildingLink/TF-VPC//modules/routes?ref=v3.0.1"

  destination    = each.value.cidr
  resource_id    = local.account1_tgw_id
  route_table_id = each.value.route_table_id
  target         = "tgw"
}
