data "aws_instance" "web_server" {
  provider    = aws.east
  instance_id = "i-0708457b903363d79"
}


resource "aws_network_interface_sg_attachment" "attach_allow_all" {
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = data.aws_instance.web_server.network_interface_id
}


resource "null_resource" "run_on_ec2" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = data.aws_instance.web_server.public_ip
      user        = "ec2-user"
      private_key = file("~/.ssh/mykey.pem")
    }

    inline = [
      "sudo python3 -m http.server 80"
    ]
  }
}
