locals {
  # Input values
  account1_tgw_ids = {
    region1 = "tgw-08893c218b96d7763"
    region2 = "tgw-0393533da883a5aec"
  }
  aws_organizations_root_arn = "arn:aws:organizations::355745333303:organization/o-seg9q2oyl4"
  vpc_cidrs = {
    region1 = "10.3.0.0/16"
    region2 = "10.4.0.0/16"
  }
  external_accounts_vpc_cidrs = {
    region1 = ["10.1.0.0/16"]
    region2 = ["10.2.0.0/16"]
  }

  # Calculated resource maps
  vpce_by_az_map_region1 = merge(flatten([for status_entry in module.fw_region1.firewall.firewall_status :
    flatten([for sync_state_entry in status_entry.sync_states :
      [for attachment_entry in sync_state_entry.attachment : { "${sync_state_entry.availability_zone}" = attachment_entry.endpoint_id }]
    ])
  ])...)
  tgw_subnet_routes_region1_map = merge([for route_table_key, route_table in module.vpc_region1.route_tables :
    { for cidr in concat([local.vpc_cidrs.region2], flatten(values(local.external_accounts_vpc_cidrs))) :
      "${route_table_key}_${cidr}" => {
        "route_table_id" = route_table.id
        "cidr"           = cidr
      }
    }
  ]...)

  vpce_by_az_map_region2 = merge(flatten([for status_entry in module.fw_region2.firewall.firewall_status :
    flatten([for sync_state_entry in status_entry.sync_states :
      [for attachment_entry in sync_state_entry.attachment : { "${sync_state_entry.availability_zone}" = attachment_entry.endpoint_id }]
    ])
  ])...)
  tgw_subnet_routes_region2_map = merge([for route_table_key, route_table in module.vpc_region2.route_tables :
    { for cidr in concat([local.vpc_cidrs.region1], flatten(values(local.external_accounts_vpc_cidrs))) :
      "${route_table_key}_${cidr}" => {
        "route_table_id" = route_table.id
        "cidr"           = cidr
      }
    }
  ]...)
}
