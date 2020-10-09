resource "aws_ebs_volume" "master_vol" {
  availability_zone = "us-east-2b"
  size              = 100
}

resource "aws_ebs_volume" "child_vol" {
  availability_zone = "us-east-2b"
  size              = 100
  count             = var.ChildAggCount
}

resource "aws_ebs_volume" "leaf_vol" {
  availability_zone = "us-east-2b"
  size              = 100
  count             = var.LeafCount
}

resource "aws_volume_attachment" "masterebs" {
  depends_on = [aws_instance.Master]
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.master_vol.id
  instance_id = aws_instance.Master.id
}

resource "aws_volume_attachment" "agg_ebs" {
  count       = var.ChildAggCount
  device_name = "/dev/sdf"
  volume_id   = element(aws_ebs_volume.child_vol.*.id,count.index)
  instance_id = element(aws_instance.Child.*.id,count.index)
}

resource "aws_volume_attachment" "leafebs" {
  
  count       = var.LeafCount
  device_name = "/dev/sdf"
  volume_id   = element(aws_ebs_volume.leaf_vol.*.id,count.index)
  instance_id = element(aws_instance.Leaf.*.id,count.index)
}

resource "null_resource" "create_filesystem_master" {
 
  depends_on = [aws_instance.Master]
  provisioner "remote-exec" {
    inline    = [
  "sleep 30",
  "chmod 600 /home/ec2-user/id_rsa",
  "chmod 755 /home/ec2-user/filesystem.sh",
  "sh -x /home/ec2-user/filesystem.sh",
    ]

  connection {
    type        = "ssh"
     host        = aws_instance.Master.public_ip
     user        = var.ssh_user
     private_key = file(var.private_key_path)
     timeout     = "1m"
     agent       = false
    }
  }
}

resource "null_resource" "create_filesystem_child" {
 
    count        = var.ChildAggCount
    depends_on   = [aws_instance.Child]

  connection {
     type        = "ssh"
     host        = element(aws_instance.Child.*.public_ip,count.index)
     user        = var.ssh_user
     private_key = file(var.private_key_path)
     timeout     = "1m"
     agent       = false
    }

  provisioner "remote-exec" {
    inline    = [
  "sleep 30",
  "chmod 600 /home/ec2-user/id_rsa",
  "chmod 755 /home/ec2-user/filesystem.sh",
  "sh -x /home/ec2-user/filesystem.sh"
    ]  
  }
}

resource "null_resource" "create_filesystem_leaf" {
 
    count        =  var.LeafCount
    depends_on   = [aws_instance.Leaf]

  connection {
     type        = "ssh"
     host        = element(aws_instance.Leaf.*.public_ip,count.index)
     user        = var.ssh_user
     private_key = file(var.private_key_path)
     timeout     = "1m"
     agent       = false
    }

  provisioner "remote-exec" {
    inline    = [
  "sleep 30",
  "chmod 600 /home/ec2-user/id_rsa",
  "chmod 755 /home/ec2-user/filesystem.sh",
  "sh -x /home/ec2-user/filesystem.sh"
    ]  
  }
}
