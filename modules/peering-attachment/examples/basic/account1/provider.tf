provider "aws" {
  alias  = "region1"
  region = "us-west-2"
}

provider "aws" {
  alias  = "region2"
  region = "us-east-2"
}
