resource "aws_iam_role_policy" "task" {
  name   = "${local.meta.team}_${local.meta.service}_${local.meta.env}_task"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task.json
}

resource "aws_iam_role" "task" {
  name = "${local.meta.team}_${local.meta.service}_${local.meta.env}_task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

data "aws_iam_policy_document" "task" {

  statement {
    actions = [
      "ec2:Describe*"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

