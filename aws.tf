data "aws_vpc" "default_vpc" {
  id = var.default_vpc_id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.yaml")
}

resource "aws_instance" "demo_server" {
  ami                    = "ami-0166fe664262f664c"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data = data.template_file.user_data.rendered
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = "DemoServer1"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "My Security Group"
  vpc_id      = data.aws_vpc.default_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = var.my_ip_cidr
  description       = "SSH"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}