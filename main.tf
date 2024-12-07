########################################################
### RESOURCES PROVISION ###
#######################################################

# Key Pair resource

resource "aws_key_pair" "Key_pair" {
  key_name   = "key_pair_name"
  public_key = file("~/.ssh/${var.Key_Pair_Name}.pub")
}

# IAM Policies resource : ec2_read_only, Metadata

resource "aws_iam_policy" "ec2_read_only_and_metadata_policy" {
  name        = "EC2ReadOnlyAndMetadataPolicy"
  description = "Read-only access to EC2 resources and Metadata"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create the IAM Role
resource "aws_iam_role" "ec2_read_only_and_metadata_role" {
  name               = "Ec2ReadOnlyRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_ec2_read_only_metatda" {
  policy_arn = aws_iam_policy.ec2_read_only_and_metadata_policy.arn
  role       = aws_iam_role.ec2_read_only_and_metadata_role.name
}

# Create the Instance Profile to be attached to ec2 instances
resource "aws_iam_instance_profile" "ec2_read_only_metadata_profile" {
  name = "Ec2ReadOnlyInstanceMetadataProfile"
  role = aws_iam_role.ec2_read_only_and_metadata_role.name
}

# ec2 Instance for the maven_jenkins_ansible Server
/*
resource "aws_instance" "maven_jenkins_ansible-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].maven_jenkins_ansible
  instance_type          = lookup(var.InstanceType, "maven_jenkins_ansible")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.maven_jenkins_ansible-SG.id}"]
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_only_metadata_profile.name
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
*/
# ec2 Instance for the Sonarqube Server

resource "aws_instance" "Sonarqube-Server" {
  ami                    = var.ami[var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]].sonarqube
  instance_type          = lookup(var.InstanceType, "sonarqube")
  subnet_id              = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  vpc_security_group_ids = ["${aws_security_group.Sonarqube-SG.id}"]
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_only_metadata_profile.name
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
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_only_metadata_profile.name
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
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_only_metadata_profile.name
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
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_only_metadata_profile.name
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
  iam_instance_profile   = aws_iam_instance_profile.ec2_read_only_metadata_profile.name
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
