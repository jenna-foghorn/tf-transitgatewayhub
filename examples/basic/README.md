# basic implementation of the TF-TransitGatewayHub module

The example provided here shows how to use the TF-TransitGatewayHub module for a solution comprised of 4 VPCs, all in the AWS us-west-2 region, where 2 of the VPCs are created in one AWS account in the same Terraform workspace that creates the Transit Gateway resource, and the other 2 VPCs are created in a separate AWS account and separate Terraform workspace.  All 4 VPCs are connected to 1 Transit Gateway located in the AWS us-west-2 region, and routes are established to enable network communication between all 4 VPCs.  Here is a list of important details of this implementation:

- Both AWS accounts used in this example belong to the same AWS Organization, which is provided in the locals key `aws_organizations_root_arn`
- Each workspace's terraform implementation of the TF-TransitGatewayHub module passes in `ram_principals` so the module will create the AWS RAM (Resouce Access Manager) resources necessary to share the TGW with multiple accounts
- The IP ranges used in all 4 VPCs do not overlap with each other, each uses a distinct /16 of the 10.0.0.0/8 private IP range
- Transit Gateways work by creating elastic network interfaces in each availability zone in one of the subnet layers of the attached VPC
  - In this example we chose to use the `protected` subnet layers (see the diagram provided by [TF_FW](https://github.com/BuildingLink/TF-FW#how-to-use-this-module))
- The Transit Gateway is created in the `account1` Terraform workspace, and then referenced in the `account2` workspace with the local `account1_tgw_id`
  - In the `account2` workspace implementation of the TF-TransitGatewayHub module, the following implementation differences exist
    - The `create_tgw` parameter is set to false in the TF-TransitGatewayHub module to tell it not to create a TGW resource
    - The `share_tgw` paratmeter is set to false to tell the module to accept the RAM share instead of request it
    - The `local.account1_tgw_id` is provided in each of the `vpc_attachments` configurations for the module to know which TGW to attach the VPCs to
- The example makes use of the [TF_VPC](https://github.com/BuildingLink/TF-VPC) and [TF_FW](https://github.com/BuildingLink/TF-FW) modules to create the supporting network resources necessary to demonstrate the TGW attachments

This module does not support peering multiple Transit Gateways that are located in multiple regions, another Terraform module would be needed to establish those peering relationships and routes.
