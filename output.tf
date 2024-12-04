
########################################################
### OUTPUT / RESUME ###
########################################################


###############################################################
# Network information
output "AWS_Network_Information" {
  description = "Network Information"
  value       = {"Region: " : var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX],  
                    "Availability Zone: " : "${var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]}a",
                    "VPC Name: " : aws_vpc.VPC-Jenkins-JavaApp-CICD.tags.Name,
                    "VPC CIDR:" : aws_vpc.VPC-Jenkins-JavaApp-CICD.cidr_block,
                    "Public Subnet:" : aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.cidr_block,
                    "Private Subnet:" : aws_subnet.Private-Subnet-Jenkins-JavaApp-CICD.cidr_block,
                } 
}

###############################################################
# Common configuration
output "Global_Configuration" {
  description = "Global Configuration"
  value       = {"Key Pair Name: " : var.Key_Pair_Name
                    "IAM Policy: " : aws_iam_policy.ec2_read_only_and_metadata_policy.arn
                    "IAM Role: " : aws_iam_role.ec2_read_only_and_metadata_role.arn
                } 
}

###############################################################
# Instances information
output "Jenkins_Instance" {
  description = "Jenkins Information"
  value       = {"ServerName:" : aws_instance.maven_jenkins_ansible-Server.tags.Name,  
                    "AMI:" : aws_instance.maven_jenkins_ansible-Server.ami ,
                    "Instant Type:" : aws_instance.maven_jenkins_ansible-Server.instance_type, 
                    "Security Group:" : aws_security_group.maven_jenkins_ansible-SG.id,
                    "Public IP:" : "http://${aws_instance.maven_jenkins_ansible-Server.public_ip}:8080"
                    "Private IP:" : aws_instance.maven_jenkins_ansible-Server.private_ip
                } 
}

output "Sonarqube_Instance" {
  description = "Sonarqube Instance"
  value       = {"ServerName:" : aws_instance.Sonarqube-Server.tags.Name,  
                    "AMI:" : aws_instance.Sonarqube-Server.ami, 
                    "Instant Type:" : aws_instance.Sonarqube-Server.instance_type, 
                    "Public IP:" : "http://${aws_instance.Sonarqube-Server.public_ip}:9000",
                    "Private IP:" : aws_instance.Sonarqube-Server.private_ip,
                    "Security Group:" : aws_security_group.Sonarqube-SG.id
                } 
}

output "Nexus_Instance" {
  description = "Nexus Instance"
  value       = {"ServerName:" : aws_instance.Nexus-Server.tags.Name,  
                    "AMI:" : aws_instance.Nexus-Server.ami, 
                    "Instant Type:" : aws_instance.Nexus-Server.instance_type, 
                    "Public IP:" : "http://${aws_instance.Nexus-Server.public_ip}:8081",
                    "Private IP:" : aws_instance.Nexus-Server.private_ip,
                    "Security Group:" : aws_security_group.Nexus-SG.id
                } 
}

output "Prometheus_Instance" {
  description = "Prometheus Instance"
  value       = {"ServerName:" : aws_instance.Prometheus-Server.tags.Name,  
                    "AMI:" : aws_instance.Prometheus-Server.ami, 
                    "Instant Type:" : aws_instance.Prometheus-Server.instance_type, 
                    "Public IP:" : "http://${aws_instance.Prometheus-Server.public_ip}:9090",
                    "Private IP:" : aws_instance.Prometheus-Server.private_ip,
                    "Security Group:" : aws_security_group.Prometheus-SG.id
                } 
}

output "Grafana_Instance" {
  description = "Grafana Instance"
  value       = {"ServerName:" : aws_instance.Grafana-Server.tags.Name,  
                    "AMI:" : aws_instance.Grafana-Server.ami,  
                    "Instant Type:" : aws_instance.Grafana-Server.instance_type, 
                    "Public IP:" : "http://${aws_instance.Grafana-Server.public_ip}:3000",
                    "Private IP:" : aws_instance.Grafana-Server.private_ip,
                    "Security Group:" : aws_security_group.Grafana-SG.id
                } 
}

output "Environment_Instances" {
  description = "Ec2 Environment Output"
  value       = { for ec2 in aws_instance.my_instances : 
                  ec2.tags.Name => { 
                    "AMI:" : ec2.ami,
                    "Instance Type:" : ec2.instance_type,
                    "Public_IP" : "http://${ec2.public_ip}:8080", 
                    "Private_IP" : ec2.private_ip,
                    "Security Group:" : aws_security_group.Env-SG.id
                  } 
                }
}


