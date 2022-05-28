data "aws_iam_policy_document" "execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${local.meta.team}_${local.meta.service}_${local.meta.env}"
  assume_role_policy = data.aws_iam_policy_document.execution_assume_role.json
}

data "aws_iam_policy_document" "execution" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "execution" {
  name   = "${local.meta.team}_${local.meta.service}_${local.meta.env}"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.execution.json
}
