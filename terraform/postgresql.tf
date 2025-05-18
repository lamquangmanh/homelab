resource "null_resource" "install_postgres" {
  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      # Add PostgreSQL APT repository for the specified version
      "sudo sh -c 'echo \"deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main\" > /etc/apt/sources.list.d/pgdg.list'",
      "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
      "sudo apt update",
      "sudo apt install -y postgresql-${var.postgres_version}",

      # Ensure PostgreSQL service is enabled and started
      "sudo systemctl enable postgresql",
      "sudo systemctl start postgresql",

      # Set the postgres user's password
      "sudo -u postgres psql -c \"ALTER USER ${var.postgres_user} WITH PASSWORD '${var.postgres_password}';\""
    ]
  }

  depends_on = [null_resource.setup_host]
}
