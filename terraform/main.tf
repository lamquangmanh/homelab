provider "null" {}

resource "null_resource" "setup_host" {
  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  # Nothing to install in this step yet
}
