data "aws_instance" "web_server" {
  provider    = aws.east
  instance_id = "i-0eada5807efb1c575"
}


# sg already exists
# resource "aws_network_interface_sg_attachment" "attach_allow_all" {
#   security_group_id    = aws_security_group.allow_all.id
#   network_interface_id = data.aws_instance.web_server.network_interface_id
# }


