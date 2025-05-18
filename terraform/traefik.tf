resource "null_resource" "install_traefik" {
  depends_on = [null_resource.install_microk8s]

  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      # Create Traefik namespace
      "sudo microk8s kubectl create namespace traefik || true",

      # Add Helm repo
      "sudo microk8s helm3 repo add traefik https://traefik.github.io/charts",
      "sudo microk8s helm3 repo update",

      # Install Traefik
      "sudo microk8s helm3 install traefik traefik/traefik --namespace traefik",

      # Optional: Wait for deployment to be ready
      "sudo microk8s kubectl rollout status deployment traefik -n traefik"
    ]
  }
}
