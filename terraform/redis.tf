resource "null_resource" "install_redis" {
  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      # Install build tools
      "sudo apt update",
      "sudo apt install -y build-essential tcl wget",

      # Download and install Redis
      "wget http://download.redis.io/releases/redis-${var.redis_version}.tar.gz -O /tmp/redis.tar.gz",
      "cd /tmp && tar xzf redis.tar.gz",
      "cd /tmp/redis-${var.redis_version} && make && sudo make install",

      # Copy and configure Redis
      "sudo mkdir -p /etc/redis",
      "sudo cp /tmp/redis-${var.redis_version}/redis.conf /etc/redis/redis.conf",
      "sudo sed -i 's/^# requirepass .*$/requirepass ${var.redis_password}/' /etc/redis/redis.conf",
      "sudo sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf",

      # Create systemd service
      "echo '[Unit]' | sudo tee /etc/systemd/system/redis.service",
      "echo 'Description=Redis In-Memory Data Store' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'After=network.target' | sudo tee -a /etc/systemd/system/redis.service",
      "echo '' | sudo tee -a /etc/systemd/system/redis.service",
      "echo '[Service]' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'ExecStop=/usr/local/bin/redis-cli -a ${var.redis_password} shutdown' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'User=root' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'Group=root' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'Restart=always' | sudo tee -a /etc/systemd/system/redis.service",
      "echo '' | sudo tee -a /etc/systemd/system/redis.service",
      "echo '[Install]' | sudo tee -a /etc/systemd/system/redis.service",
      "echo 'WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/redis.service",

      # Reload systemd and start Redis
      "sudo systemctl daemon-reload",
      "sudo systemctl enable redis",
      "sudo systemctl start redis"
    ]
  }

  depends_on = [null_resource.setup_host]
}
