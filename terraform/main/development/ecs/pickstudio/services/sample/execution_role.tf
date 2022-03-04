data "aws_iam_policy_document" "execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name = "ecs-execution-role-storage-flight"
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
      "arn:aws:kms:ap-northeast-2:314695318048:key/e452b6c4-f92f-4757-a2c6-0adc5abb4809"
    ]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:ap-northeast-2:314695318048:parameter/ecs/hoian_webapp_production/task_storage_flight/*"
    ]
  }
}

resource "aws_iam_role_policy" "execution" {
  name = "execution-policy-storage-flight"
  role = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.execution.json
}