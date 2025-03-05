output "tgw_peering_attachment_id" {
  value = aws_ec2_transit_gateway_peering_attachment.requester.id
}

output "tgw_peering_attachment_timer" {
  value = time_sleep.requester
}
