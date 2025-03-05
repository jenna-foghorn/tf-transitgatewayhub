module "tgw" {
  source = "../../.."

  name                                  = "test-tgw"
  description                           = "My TGW shared with several other AWS accounts"
  amazon_side_asn                       = 64532
  enable_auto_accept_shared_attachments = true
  enable_mutlicast_support              = false

  vpc_attachments = {}

  share_tgw                     = true
  ram_allow_external_principals = true
  ram_principals                = [local.aws_organizations_root_arn]
  tags = {
    Name        = "test-tgw"
    Environment = "test"
  }
}
