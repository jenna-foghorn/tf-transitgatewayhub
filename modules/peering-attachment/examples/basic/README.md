# basic implementation of the peering-attachment module

The example provided here shows how to use the peering-attachment module for a solution comprised of 4 VPCs, two in the AWS us-west-2 region and 2 in the AWS us-east-2 region, where 2 of the VPCs are created in one AWS account in the same Terraform workspace that creates the Transit Gateway resource, and the other 2 VPCs are created in a separate AWS account and separate Terraform workspace.  Each pair of regional VPCs are connected to a regional Transit Gateway located in the same region, for a total of 2 Transit Gateways, and routes are established to enable network communication between each of the regional Transit Gateway pairings.  Here is a list of important details of this implementation:

- Both AWS accounts used in this example belong to the same AWS Organization, which is provided in the locals key `aws_organizations_root_arn`
- The IP ranges used in all 4 VPCs do not overlap with each other, each uses a distinct /16 of the 10.0.0.0/8 private IP range
- Transit Gateways work by creating elastic network interfaces in each availability zone in one of the subnet layers of the attached VPC
  - In this example we chose to use the `protected` subnet layers (see the diagram provided by [TF_FW](https://github.com/BuildingLink/TF-FW#how-to-use-this-module))
- The Transit Gateways are created in the `account1` Terraform workspace, and then referenced in the `account2` workspace with the local `account1_tgw_ids`
- The 2 Transit Gateways are peered together to form an inter-regional transit network
  - Region to region transit gateway routes are created
- The example makes use of the [TF_VPC](https://github.com/BuildingLink/TF-VPC) and [TF_FW](https://github.com/BuildingLink/TF-FW) modules to create the supporting network resources necessary to demonstrate the TGW attachments

