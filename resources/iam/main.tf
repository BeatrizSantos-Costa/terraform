################################################################################
# IAM
################################################################################

resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = var.iam_role_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "vpc-flow-logs.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy_vpc_flow_logs" {
  name   = var.iam_policy_vpc_flow_logs
  role   = aws_iam_role.vpc_flow_logs_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
