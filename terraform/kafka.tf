resource "null_resource" "install_kafka" {
  connection {
    type        = "ssh"
    user        = var.user
    host        = var.host
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://downloads.apache.org/kafka/${var.kafka_version}/kafka_2.13-${var.kafka_version}.tgz -O /tmp/kafka.tgz",
      "sudo mkdir -p /opt/kafka",
      "sudo tar -xzf /tmp/kafka.tgz -C /opt/kafka --strip-components=1",
      "sudo tee /etc/systemd/system/kafka.service > /dev/null <<EOF\n[Unit]\nDescription=Apache Kafka\nAfter=network.target\n\n[Service]\nType=simple\nExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties\nExecStop=/opt/kafka/bin/kafka-server-stop.sh\nRestart=on-abnormal\n\n[Install]\nWantedBy=multi-user.target\nEOF",
      "sudo systemctl daemon-reexec",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable kafka",
      "sudo systemctl start kafka"
    ]
  }

  depends_on = [null_resource.setup_host]
}

# Uncomment the following lines to enable Kafka installation
# variable "kafka_version" {
#   type        = string
#   default     = "3.6.1"
#   description = "value of the Kafka version to install"
# }

# variable "kafka_user" {
#   type        = string
#   default     = "admin"
#   description = "Kafka SASL user"
# }

# variable "kafka_password" {
#   type        = string
#   default     = "admin123"
#   description = "Kafka SASL password"
# }

# resource "null_resource" "install_kafka" {
#   connection {
#     type        = "ssh"
#     user        = var.user
#     host        = var.host
#     private_key = file(var.private_key_path)
#   }

#   provisioner "remote-exec" {
#     inline = [
#       # Install Java
#       "sudo apt update",
#       "sudo apt install -y openjdk-11-jdk wget net-tools",

#       # Download Kafka
#       "wget https://downloads.apache.org/kafka/${var.kafka_version}/kafka_2.13-${var.kafka_version}.tgz -O /tmp/kafka.tgz",
#       "cd /opt && sudo tar -xzf /tmp/kafka.tgz && sudo mv kafka_2.13-${var.kafka_version} kafka",

#       # Create system user
#       "sudo useradd -r -s /bin/false kafka || true",

#       # Change ownership
#       "sudo chown -R kafka:kafka /opt/kafka",

#       # Configure SASL authentication
#       "echo 'listener.name.sasl_plaintext.scram-sha-256.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\\\"${var.kafka_user}\\\" password=\\\"${var.kafka_password}\\\";' | sudo tee -a /opt/kafka/config/server.properties",
#       "echo 'listeners=SASL_PLAINTEXT://:9092' | sudo tee -a /opt/kafka/config/server.properties",
#       "echo 'security.inter.broker.protocol=SASL_PLAINTEXT' | sudo tee -a /opt/kafka/config/server.properties",
#       "echo 'sasl.mechanism.inter.broker.protocol=SCRAM-SHA-256' | sudo tee -a /opt/kafka/config/server.properties",
#       "echo 'sasl.enabled.mechanisms=SCRAM-SHA-256' | sudo tee -a /opt/kafka/config/server.properties",

#       # Set up Zookeeper systemd service
#       "echo '[Unit]' | sudo tee /etc/systemd/system/zookeeper.service",
#       "echo 'Description=Apache Zookeeper Server' | sudo tee -a /etc/systemd/system/zookeeper.service",
#       "echo '[Service]' | sudo tee -a /etc/systemd/system/zookeeper.service",
#       "echo 'ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties' | sudo tee -a /etc/systemd/system/zookeeper.service",
#       "echo 'User=kafka' | sudo tee -a /etc/systemd/system/zookeeper.service",
#       "echo 'Restart=on-abnormal' | sudo tee -a /etc/systemd/system/zookeeper.service",
#       "echo '[Install]' | sudo tee -a /etc/systemd/system/zookeeper.service",
#       "echo 'WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/zookeeper.service",

#       # Set up Kafka systemd service
#       "echo '[Unit]' | sudo tee /etc/systemd/system/kafka.service",
#       "echo 'Description=Apache Kafka Server' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo 'After=zookeeper.service' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo '[Service]' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo 'ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo 'User=kafka' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo 'Restart=on-abnormal' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo '[Install]' | sudo tee -a /etc/systemd/system/kafka.service",
#       "echo 'WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/kafka.service",

#       # Reload and start services
#       "sudo systemctl daemon-reload",
#       "sudo systemctl enable zookeeper",
#       "sudo systemctl start zookeeper",
#       "sleep 5",
#       "sudo systemctl enable kafka",
#       "sudo systemctl start kafka"
#     ]
#   }
# }
