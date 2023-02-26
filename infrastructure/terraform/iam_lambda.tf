resource "aws_iam_role" "scraper-lambda-exec-role" {
  name               = "${local.project}-lambda-exec-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "scraper-lambda-basic-exec-policy" {
  role       = aws_iam_role.scraper-lambda-exec-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "scraper-lambda-exec-vpc-policy" {
  role       = aws_iam_role.scraper-lambda-exec-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "scraper-lambda-exec-internal-policy-attach" {
  role       = aws_iam_role.scraper-lambda-exec-role.name
  policy_arn = aws_iam_policy.scraper-lambda-exec-internal-policy.arn
}

data "aws_iam_policy_document" "scraper-lambda-exec-internal-policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucket",
      "s3:GetObjectVersion",
      "s3:ListMultipartUploadParts"
    ]

    resources = [
      "${aws_s3_bucket.scraper.arn}/*",
      aws_s3_bucket.scraper.arn,
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "events:DescribeRule",
      "events:ListRules",
      "events:ListRuleNamesByTarget",
      "events:ListTargetsByRule",
      "events:PutRule",
      "events:PutTargets",
      "events:TagResource",
    ]

    resources = [
      "arn:aws:events:${local.aws_region}:${local.aws_account_id}:rule/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "events:DeleteRule",
      "events:RemoveTargets",
    ]

    resources = [
      "arn:aws:events:${local.aws_region}:${local.aws_account_id}:rule/scraper-*"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunction",
      "lambda:AddPermission",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "scraper-lambda-exec-internal-policy" {
  name   = "${local.project}-lambda-exec-internal-role"
  policy = data.aws_iam_policy_document.scraper-lambda-exec-internal-policy.json
}