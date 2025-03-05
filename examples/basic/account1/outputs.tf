output "main_vpc_id" {
  value = module.vpc_main.vpc.id
}

output "main_subnet_ids" {
  value = {
    firewall  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_main.subnets["firewall_${subnet_name}"].id]
    protected = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_main.subnets["protected_${subnet_name}"].id]
    private   = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_main.subnets["private_${subnet_name}"].id]
    isolated  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_main.subnets["isolated_${subnet_name}"].id]
  }
}

output "secondary_vpc_id" {
  value = module.vpc_secondary.vpc.id
}

output "secondary_subnet_ids" {
  value = {
    firewall  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_secondary.subnets["firewall_${subnet_name}"].id]
    protected = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_secondary.subnets["protected_${subnet_name}"].id]
    private   = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_secondary.subnets["private_${subnet_name}"].id]
    isolated  = [for subnet_name, subnet_data in var.subnet_layers.protected.subnets : module.vpc_secondary.subnets["isolated_${subnet_name}"].id]
  }
}

output "tgw_id" {
  value = module.tgw.ec2_transit_gateway_id
}
