resource "null_resource" "Env_Substuite" {
 
  depends_on = [aws_instance.Master]
  
  provisioner "remote-exec" {
    inline    = [
  "sleep 60",
  "chmod 755 substenv.sh",
  "touch privateIP.txt",
  "export MA01_INTERNAL_IP=${aws_instance.Master.private_ip}",
  "export CA00_INTERNAL_IP=${aws_instance.Child.0.private_ip}",
  "export CA01_INTERNAL_IP=${aws_instance.Child.1.private_ip}",
  "export CA02_INTERNAL_IP=${aws_instance.Child.2.private_ip}",
  "export CA03_INTERNAL_IP=${aws_instance.Child.3.private_ip}",
  "export CA04_INTERNAL_IP=${aws_instance.Child.4.private_ip}",
  "export CA05_INTERNAL_IP=${aws_instance.Child.5.private_ip}",
  "export LF00_INTERNAL_IP=${aws_instance.Leaf.0.private_ip}",
  "export LF01_INTERNAL_IP=${aws_instance.Leaf.1.private_ip}",
  "export LF02_INTERNAL_IP=${aws_instance.Leaf.2.private_ip}",
  "export LF03_INTERNAL_IP=${aws_instance.Leaf.3.private_ip}",
  "export LF04_INTERNAL_IP=${aws_instance.Leaf.4.private_ip}",
  "export LF05_INTERNAL_IP=${aws_instance.Leaf.5.private_ip}",
  "export LF06_INTERNAL_IP=${aws_instance.Leaf.6.private_ip}",
  "export LF07_INTERNAL_IP=${aws_instance.Leaf.7.private_ip}",
  "export LF08_INTERNAL_IP=${aws_instance.Leaf.8.private_ip}",
  "export LF09_INTERNAL_IP=${aws_instance.Leaf.9.private_ip}",
  "export LF10_INTERNAL_IP=${aws_instance.Leaf.10.private_ip}",
  "export LF11_INTERNAL_IP=${aws_instance.Leaf.11.private_ip}",
  "export LF12_INTERNAL_IP=${aws_instance.Leaf.12.private_ip}",
  "export LF13_INTERNAL_IP=${aws_instance.Leaf.13.private_ip}",
  "export LF14_INTERNAL_IP=${aws_instance.Leaf.14.private_ip}",
  "export LF15_INTERNAL_IP=${aws_instance.Leaf.15.private_ip}",
  "export LF16_INTERNAL_IP=${aws_instance.Leaf.16.private_ip}",
  "export LF17_INTERNAL_IP=${aws_instance.Leaf.17.private_ip}",
  "export LF18_INTERNAL_IP=${aws_instance.Leaf.18.private_ip}",
  "export LF19_INTERNAL_IP=${aws_instance.Leaf.19.private_ip}",
  "export LF20_INTERNAL_IP=${aws_instance.Leaf.20.private_ip}",
  "export LF21_INTERNAL_IP=${aws_instance.Leaf.21.private_ip}",
  "export LF22_INTERNAL_IP=${aws_instance.Leaf.22.private_ip}",
  "export LF23_INTERNAL_IP=${aws_instance.Leaf.23.private_ip}",
  "export LF24_INTERNAL_IP=${aws_instance.Leaf.24.private_ip}",
  "sh -x /home/ec2-user/substenv.sh",
  "chmod 755 memsql_cluster_install.yaml",
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

resource "null_resource" "cluster_install" {
 
  depends_on = [null_resource.Env_Substuite]
  
  provisioner "remote-exec" {
    inline    = [
    "sleep 180",
    "sudo systemctl start memsql-studio",
    "/usr/bin/memsql-deploy setup-cluster --cluster-file /home/ec2-user/memsql_cluster_install.yaml --yes",
    "memsql-admin optimize --yes",    
    ]

  connection {
    type        = "ssh"
     host        = aws_instance.Master.public_ip
     user        = var.ssh_user
     private_key = file(var.private_key_path)
     timeout     = "15m"
     agent       = false
    }
  }
}