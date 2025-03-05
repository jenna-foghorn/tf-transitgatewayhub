locals {
  # Input values
  account1_tgw_id             = "tgw-0373c5aa259588dd2"
  aws_organizations_root_arn  = "arn:aws:organizations::355745333303:organization/o-seg9q2oyl4"
  external_accounts_vpc_cidrs = ["10.1.0.0/16", "10.2.0.0/16"]

  # Calculated resource maps
  vpce_by_az_map_main = merge(flatten([for status_entry in module.fw_main.firewall.firewall_status :
    flatten([for sync_state_entry in status_entry.sync_states :
      [for attachment_entry in sync_state_entry.attachment : { "${sync_state_entry.availability_zone}" = attachment_entry.endpoint_id }]
    ])
  ])...)
  tgw_routes_main_map = merge([for route_table_key, route_table in module.vpc_main.route_tables :
    { for cidr in concat(local.external_accounts_vpc_cidrs, [module.vpc_secondary.vpc.cidr_block]) :
      "${route_table_key}_${cidr}" => {
        "route_table_id" = route_table.id
        "cidr"           = cidr
      }
    }
  ]...)

  vpce_by_az_map_secondary = merge(flatten([for status_entry in module.fw_secondary.firewall.firewall_status :
    flatten([for sync_state_entry in status_entry.sync_states :
      [for attachment_entry in sync_state_entry.attachment : { "${sync_state_entry.availability_zone}" = attachment_entry.endpoint_id }]
    ])
  ])...)
  tgw_routes_secondary_map = merge([for route_table_key, route_table in module.vpc_secondary.route_tables :
    { for cidr in concat(local.external_accounts_vpc_cidrs, [module.vpc_main.vpc.cidr_block]) :
      "${route_table_key}_${cidr}" => {
        "route_table_id" = route_table.id
        "cidr"           = cidr
      }
    }
  ]...)
}
