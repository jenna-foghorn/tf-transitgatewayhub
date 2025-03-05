# peering-attachment module

This repo contains a [Terraform module](https://www.terraform.io/docs/modules/usage.html) which creates Transit Gateway peering attachments given two transit gateway ids and their associated route table ids. This module is designed to have two AWS providers passed to it on implementation, one for the requester transit gateway, and the other for the accepter transit gateway.  This module will wait on the peering attachment to be created, and will also output the wait timer for the implementation to use as an explicit dependency when adding transit gateway routes.

## Example Usage
```
module "tgw_region1_peering_region2" {
  providers = {
    aws.requester = aws.region1
    aws.accepter  = aws.region2
  }

  source = "git@github.com:BuildingLink/TF-TransitGatewayHub//modules/peering-attachment?ref=v1.0.0"

  requester_tgw_id                   = module.tgw_region1.ec2_transit_gateway_id
  requester_tgw_route_table_id       = module.tgw_region1.ec2_transit_gateway_route_table_id
  requester_tgw_peering_routes_cidrs = concat([local.vpc_cidrs.region1], local.external_accounts_vpc_cidrs.region1)
  accepter_tgw_id                    = module.tgw_region2.ec2_transit_gateway_id
  accepter_tgw_route_table_id        = module.tgw_region2.ec2_transit_gateway_route_table_id
  accepter_tgw_peering_routes_cidrs  = concat([local.vpc_cidrs.region2], local.external_accounts_vpc_cidrs.region2)

  tag_map = {
    Name        = "test-tgw-peering-r1-r2"
    Environment = "test"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.24 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | >= 5.24 |
| <a name="provider_aws.requester"></a> [aws.requester](#provider\_aws.requester) | >= 5.24 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.9 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_peering_attachment.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment) | resource |
| [aws_ec2_transit_gateway_peering_attachment_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment_accepter) | resource |
| [aws_ec2_transit_gateway_route.accepter_peering_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.requester_peering_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [time_sleep.requester](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_tgw_id"></a> [accepter\_tgw\_id](#input\_accepter\_tgw\_id) | The transit gateway id of the accepter tgw. | `string` | n/a | yes |
| <a name="input_accepter_tgw_peering_routes_cidrs"></a> [accepter\_tgw\_peering\_routes\_cidrs](#input\_accepter\_tgw\_peering\_routes\_cidrs) | A list of CIDR ranges associated with the accepter transit gateway to route to the peering attachment. | `list(string)` | n/a | yes |
| <a name="input_accepter_tgw_route_table_id"></a> [accepter\_tgw\_route\_table\_id](#input\_accepter\_tgw\_route\_table\_id) | The transit gateway route table id of the accepter tgw. | `string` | n/a | yes |
| <a name="input_peering_attachment_wait"></a> [peering\_attachment\_wait](#input\_peering\_attachment\_wait) | Time duration to delay.  This gives the peering attachments time to be created so that the creation of transit gateway routes do not fail. For example, 180s for 180 seconds or 3m for 3 minutes. | `string` | `"180s"` | no |
| <a name="input_requester_tgw_id"></a> [requester\_tgw\_id](#input\_requester\_tgw\_id) | The transit gateway id of the requester tgw. | `string` | n/a | yes |
| <a name="input_requester_tgw_peering_routes_cidrs"></a> [requester\_tgw\_peering\_routes\_cidrs](#input\_requester\_tgw\_peering\_routes\_cidrs) | A list of CIDR ranges associated with the requester transit gateway to route to the peering attachment. | `list(string)` | n/a | yes |
| <a name="input_requester_tgw_route_table_id"></a> [requester\_tgw\_route\_table\_id](#input\_requester\_tgw\_route\_table\_id) | The transit gateway route table id of the requester tgw. | `string` | n/a | yes |
| <a name="input_tag_map"></a> [tag\_map](#input\_tag\_map) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tgw_peering_attachment_id"></a> [tgw\_peering\_attachment\_id](#output\_tgw\_peering\_attachment\_id) | n/a |
| <a name="output_tgw_peering_attachment_timer"></a> [tgw\_peering\_attachment\_timer](#output\_tgw\_peering\_attachment\_timer) | n/a |
<!-- END_TF_DOCS -->
