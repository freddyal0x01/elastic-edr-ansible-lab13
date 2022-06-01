
resource "linode_sshkey" "foo" {
  label      = "foo"
  ssh_key = chomp(file("/home/vagrant/elastic-edr-ansible-lab13/keys/devops.pub"))
}
resource "linode_instance" "elk" {
  image   = "linode/ubuntu20.04"
  label   = "elk"
  region  = "us-southeast"
  type    = "g6-dedicated-4"
  authorized_keys = [linode_sshkey.foo.ssh_key]
  connection {
    host = self.ip_address
    user = "root"
    type = "ssh"
    agent = false
    timeout = "3m"
    private_key = var.ansible_ssh_key_private
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo adduser --disabled-password --gecos '' ansible",
      "sudo mkdir -p /home/ansible/.ssh",
      "sudo touch /home/ansible/.ssh/authorized_keys",
      "sudo echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTrGMBBTHWKFP7ik3Z31y7aH8QU9fAf5/ndkNwlnHZE freddyal@elmajestic' > authorized_keys",
      "sudo mv authorized_keys /home/ansible/.ssh",
      "sudo chown -R ansible:ansible /home/ansible/.ssh",
      "sudo chmod 700 /home/ansible/.ssh",
      "sudo chmod 600 /home/ansible/.ssh/authorized_keys",
      "sudo usermod -aG sudo ansible",
      "sudo echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers",
      "sudo apt-get update"
    ]
  }
}
resource "linode_firewall" "elk-firewall" {
  label           = "elk-firewall"

  linodes         = [linode_instance.elk.id]
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"
  inbound {
    label     = "allow-ssh"
    protocol  = "TCP"
    ports     = "22"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }

  inbound {
    label     = "allow-http"
    protocol  = "TCP"
    ports     = "80"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }

  inbound {
    label     = "allow-https"
    protocol  = "TCP"
    ports     = "443"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }

  inbound {
    label     = "allow-fleet"
    protocol  = "TCP"
    ports     = "8220"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }

  inbound {
    label     = "allow-elasticsearch"
    protocol  = "TCP"
    ports     = "9200"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }


  outbound {
    label     = "allow-outbound-udp"
    protocol  = "UDP"
    ports     = "1-65535"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }

  outbound {
    label     = "allow-outbound-tcp"
    protocol  = "TCP"
    ports     = "1-65535"
    action    = "ACCEPT"
    ipv4      = ["0.0.0.0/0"]
    ipv6      = ["::/0"]
  }
}
