output "region1_vpc_id" {
  value = module.vpc_region1.vpc.id
}

output "region1_subnet_ids" {
  value = {
    firewall  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region1.subnets["firewall_${subnet_name}"].id]
    protected = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region1.subnets["protected_${subnet_name}"].id]
    private   = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region1.subnets["private_${subnet_name}"].id]
    isolated  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region1.subnets["isolated_${subnet_name}"].id]
  }
}

output "region2_vpc_id" {
  value = module.vpc_region2.vpc.id
}

output "region2_subnet_ids" {
  value = {
    firewall  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region2.subnets["firewall_${subnet_name}"].id]
    protected = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region2.subnets["protected_${subnet_name}"].id]
    private   = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region2.subnets["private_${subnet_name}"].id]
    isolated  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_region2.subnets["isolated_${subnet_name}"].id]
  }
}

output "region1_tgw_id" {
  value = module.tgw_region1.ec2_transit_gateway_id
}

output "region2_tgw_id" {
  value = module.tgw_region2.ec2_transit_gateway_id
}
