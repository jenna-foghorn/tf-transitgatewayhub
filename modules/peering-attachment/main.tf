resource "aws_ec2_transit_gateway_peering_attachment" "requester" {
  provider = aws.requester

  peer_account_id         = data.aws_caller_identity.accepter.account_id
  peer_region             = data.aws_region.accepter.name
  peer_transit_gateway_id = var.accepter_tgw_id
  transit_gateway_id      = var.requester_tgw_id
  tags                    = var.tag_map
}

resource "time_sleep" "requester" {
  depends_on = [aws_ec2_transit_gateway_peering_attachment.requester]

  create_duration = var.peering_attachment_wait
}

resource "aws_ec2_transit_gateway_route" "requester_peering_routes" {
  provider = aws.requester

  for_each = toset(var.accepter_tgw_peering_routes_cidrs)

  transit_gateway_route_table_id = var.requester_tgw_route_table_id
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.requester.id

  depends_on = [time_sleep.requester]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accepter" {
  provider = aws.accepter

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
  tags                          = var.tag_map
}

resource "aws_ec2_transit_gateway_route" "accepter_peering_routes" {
  provider = aws.accepter

  for_each = toset(var.requester_tgw_peering_routes_cidrs)

  transit_gateway_route_table_id = var.accepter_tgw_route_table_id
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.requester.id

  depends_on = [time_sleep.requester]
}
