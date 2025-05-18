resource "null_resource" "install_argocd" {
  depends_on = [null_resource.install_microk8s]

  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      # Create ArgoCD namespace
      "sudo microk8s kubectl create namespace argocd || true",

      # Install ArgoCD using manifests
      "sudo microk8s kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml",

      # Patch ArgoCD server to use ingress or LoadBalancer
      "sudo microk8s kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'",

      # Wait for ArgoCD to be ready
      "sudo microk8s kubectl rollout status deployment argocd-server -n argocd"
    ]
  }
}
