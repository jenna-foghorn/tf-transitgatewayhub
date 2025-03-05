variable "accepter_tgw_id" {
  description = "The transit gateway id of the accepter tgw."
  type        = string
}

variable "accepter_tgw_route_table_id" {
  description = "The transit gateway route table id of the accepter tgw."
  type        = string
}

variable "accepter_tgw_peering_routes_cidrs" {
  description = "A list of CIDR ranges associated with the accepter transit gateway to route to the peering attachment."
  type        = list(string)
}

variable "requester_tgw_id" {
  description = "The transit gateway id of the requester tgw."
  type        = string
}

variable "requester_tgw_route_table_id" {
  description = "The transit gateway route table id of the requester tgw."
  type        = string
}

variable "requester_tgw_peering_routes_cidrs" {
  description = "A list of CIDR ranges associated with the requester transit gateway to route to the peering attachment."
  type        = list(string)
}

variable "tag_map" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "peering_attachment_wait" {
  description = "Time duration to delay.  This gives the peering attachments time to be created so that the creation of transit gateway routes do not fail. For example, 180s for 180 seconds or 3m for 3 minutes."
  type        = string
  default     = "180s"
}
