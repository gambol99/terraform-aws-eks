## Data sources for the current AWS account and region
data "aws_caller_identity" "current" {}
## Data source for the current AWS region
data "aws_region" "current" {}
