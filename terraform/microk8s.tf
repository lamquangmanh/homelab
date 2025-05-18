resource "null_resource" "install_microk8s" {
  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      # Install MicroK8s
      "sudo apt update",
      "sudo snap install microk8s --classic --channel=1.29/stable",

      # Add user to MicroK8s group
      "sudo usermod -a -G microk8s ${var.user}",
      "sudo chown -f -R ${var.user} ~/.kube",

      # Enable essential MicroK8s add-ons
      "sudo microk8s enable dns storage metallb dashboard",

      # Wait for MicroK8s to be ready
      "sudo microk8s status --wait-ready"
    ]
  }
}
