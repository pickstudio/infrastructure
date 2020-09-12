data "template_file" "ec2" {
  template = "${file("${path.module}/files/setup.sh")}"

  vars = {
    github_accounts = var.github_accounts
  }
}
