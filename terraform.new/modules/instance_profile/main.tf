resource "aws_iam_instance_profile" "profile" {
  name = "${var.name}_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "${var.name}_role"

  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "policy" {
  name        = "${var.name}_policy"
  description = "A bastion policy"

  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
