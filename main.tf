########################################################
### RESOURCES PROVISION ###
#######################################################

# Key Pair resource

resource "aws_key_pair" "Key_pair" {
  key_name   = "key_pair_name"
  public_key = file("~/.ssh/${var.Key_Pair_Name}.pub")
}

# ec2 Instance for the maven_jenkins_ansible Server

resource "aws_instance" "maven_jenkins_ansible-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].maven_jenkins_ansible
  instance_type          = lookup(var.InstanceType, "maven_jenkins_ansible")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.maven_jenkins_ansible-SG.id}"]
  iam_instance_profile   = var.EC2_iam_role
  key_name               = aws_key_pair.Key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              ${file("scripts/jenkins-maven-ansible-install.sh")}
              ${file("scripts/install-node-exporter.sh")}
              EOF

  tags = {
    Name = lookup(var.ServerNames, "maven_jenkins_ansible")
  }

  // Nexus, Sonarqube, prometheus, grafana, env must run firts before maven_jenkins_ansible
  //depends_on = [aws_instance.Nexus-Server, aws_instance.Sonarqube-Server, aws_instance.Prometheus-Server, aws_instance.Grafana-Server, aws_instance.my_instances]
}

# ec2 Instance for the Sonarqube Server

resource "aws_instance" "Sonarqube-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].sonarqube
  instance_type          = lookup(var.InstanceType, "sonarqube")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.Sonarqube-SG.id}"]
  iam_instance_profile   = var.EC2_iam_role
  key_name               = aws_key_pair.Key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              ${file("scripts/sonarqube-install.sh")}
              ${file("scripts/install-node-exporter.sh")}
              EOF

  tags = {
    Name = lookup(var.ServerNames, "sonarqube")
  }
}

# ec2 Instance for the Nexus Server

 resource "aws_instance" "Nexus-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].nexus
  instance_type          = lookup(var.InstanceType, "nexus")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.Nexus-SG.id}"]
  iam_instance_profile   = var.EC2_iam_role
  key_name               = aws_key_pair.Key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              ${file("scripts/nexus-install.sh")}
              ${file("scripts/install-node-exporter.sh")}
              EOF

  tags = {
    Name = lookup(var.ServerNames, "nexus")
  }
} 




# ec2 Instance for the Prometheus Server

resource "aws_instance" "Prometheus-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].prometheus
  instance_type          = lookup(var.InstanceType, "prometheus")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.Prometheus-SG.id}"]
  iam_instance_profile   = var.EC2_iam_role
  key_name               = aws_key_pair.Key_pair.key_name

  user_data = file("scripts/prometheus.sh")

  tags = {
    Name = lookup(var.ServerNames, "prometheus")
  }
}

# ec2 Instance for the Grafana Server

resource "aws_instance" "Grafana-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].grafana
  instance_type          = lookup(var.InstanceType, "grafana")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.Grafana-SG.id}"]
  iam_instance_profile   = var.EC2_iam_role
  key_name               = aws_key_pair.Key_pair.key_name

  user_data = file("scripts/install-grafana.sh")

  tags = {
    Name = lookup(var.ServerNames, "grafana")
  }
}

# ec2 Instance for the Env Server

resource "aws_instance" "my_instances" {
  count                  = var.instance_count
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].env
  instance_type          = lookup(var.InstanceType, "env")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.Env-SG.id}"]
  iam_instance_profile   = var.EC2_iam_role
  key_name               = aws_key_pair.Key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              ${file("scripts/env-install.sh")}
              ${file("scripts/install-node-exporter.sh")}
              EOF

  tags = {
    Name = var.instance_names[count.index]
  }
}
