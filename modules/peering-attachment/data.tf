data "aws_caller_identity" "accepter" {
  provider = aws.accepter
}

data "aws_region" "accepter" {
  provider = aws.accepter
}
