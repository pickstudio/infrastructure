data "template_cloudinit_config" "ec2" {
  gzip = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloudinit.yaml", {
      github_accounts = var.github_accounts
    })
  }
}
