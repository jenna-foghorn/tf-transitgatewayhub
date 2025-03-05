# no_vpc implementation of the TF-TransitGatewayHub module

The example provided here differs from the basic example in that it does not provision a VPC in account1, but rather only provisions the TGW and is attached from the VPCs in account2.  It also does not pass in a value for transit_gateway_cidr_blocks.
