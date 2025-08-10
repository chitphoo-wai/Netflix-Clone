resource "aws_instance" "web" {
  ami                    = "ami-06c4be2792f419b7b" #change ami id for different region -> this is ap-southeast-1 region
  instance_type          = "t2.large"              #recommanded to use
  key_name               = "jenkin"                #change keypair name as per your setup in AWS
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]
  subnet_id              = "subnet-00eabc290d8805c8e" #change ur subnet id
  user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "Jenkins-SonarQube" #any name you can given
  }

  root_block_device {
    volume_size = 40
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0d1ab1e87bc0623b1" ###change vpc id

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}