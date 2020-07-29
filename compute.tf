resource "aws_instance" "Master" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.xlarge"
  associate_public_ip_address = "true"
  subnet_id     =  data.aws_subnet.example.id
  key_name      =  aws_key_pair.deployer.key_name
  user_data     =  file("postinstall.sh")
  tags = {
    Name = "Master"
  }
 }

 resource "aws_instance" "Child" {
  count         = var.ChildAggCount
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.xlarge"
  associate_public_ip_address = "true"
  subnet_id     =  data.aws_subnet.example.id
  key_name      =  aws_key_pair.deployer.key_name
  user_data     =  file("postinstall.sh")
  tags = {
    Name = "Child ${count.index}"
  } 
 }

resource "aws_instance" "Leaf" {
  count         = var.LeafCount
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.xlarge"
  associate_public_ip_address = "true"
  subnet_id     =  data.aws_subnet.example.id
  key_name      =  aws_key_pair.deployer.key_name
  user_data     =  file("postinstall.sh")
  tags = {
    Name = "Leaf ${count.index}"
  }
}

resource "null_resource" "copy-files-master" {

  connection {
    type        = "ssh"
    host        = aws_instance.Master.public_ip
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    timeout     = "1m"
    agent       = false
  }
  
  provisioner "file" {
    source      = "id_rsa"
    destination = "/home/ec2-user/id_rsa"
    }

  provisioner "file" {
    source      = "filesystem.sh"
    destination = "/home/ec2-user/filesystem.sh"
  }

  provisioner "file" {
    source      = "memsql_cluster_install.yaml"
    destination = "/home/ec2-user/memsql_cluster_install.yaml"
  }

  provisioner "file" {
    source      = "substenv.sh"
    destination = "/home/ec2-user/substenv.sh"
  } 
}

resource "null_resource" "copy-files-ChildAgg" {
  
  count         = var.ChildAggCount

  connection {
    type        = "ssh"
    host        = element(aws_instance.Child.*.public_ip,count.index)
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    timeout     = "1m"
    agent       = false
  }

  provisioner "file" {
    source      = "id_rsa"
    destination = "/home/ec2-user/id_rsa"
     }

  provisioner "file" {
    source      = "filesystem.sh"
    destination = "/home/ec2-user/filesystem.sh"
  } 
}

resource "null_resource" "copy-files-Leaf" {
  
  count         = var.LeafCount
  connection {
    type        = "ssh"
    host        = element(aws_instance.Leaf.*.public_ip,count.index)
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    timeout     = "1m"
    agent       = false
  }

  provisioner "file" {
    source      = "id_rsa"
    destination = "/home/ec2-user/id_rsa"
      }

  provisioner "file" {
    source      = "filesystem.sh"
    destination = "/home/ec2-user/filesystem.sh"
  }
}