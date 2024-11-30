```hcl
terraform {

}

module "apache" {
  source = "./terraform-aws-apache-example"
  my_ip_cidr = "My Ip Address/32"
  default_vpc_id = "vpc-000000000000"
  public_key = "ssh-rsa AABBCC..."
  instance_type = "t2.micro"
}

output "demo_server_public_ip" {
  value = aws_instance.demo_server.public_ip
}

```
