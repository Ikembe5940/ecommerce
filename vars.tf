variable "AVAILABLE_REGIONS" {
  type = map(string)

  default = {
    "1" = "us-east-1"
    "2" = "us-east-2"
    "3" = "us-west-1"
    "4" = "us-west-2"
  }
}

variable "AWS_REGIONS_INDEX" {
  type        = string
  description = "Availabe Regions: [1] us-east-1, [2] us-east-2, [3] us-west-1, [4] us-west-2"

  validation {
    condition     = can(regex("^(1|2|3|4)$", var.AWS_REGIONS_INDEX))
    error_message = "Please enter a value between 1 and 4"
  }

  default = 1 // Insfrastructure will be deployed in us-east-1
}


variable "ami" {
  type = map(object({
    maven_jenkins_ansible = string //Amazon Linux 2023 
    nexus                 = string //Amazon Linux 2023
    sonarqube             = string //Ubuntu Server 22.04 LTS
    prometheus            = string //Ubuntu Server 22.04 LTS
    grafana               = string //Ubuntu Server 22.04 LTS
    env                   = string //Amazon Linux 2023
  }))

  description = "AMIs Reserved for the JavaApp project"

  default = {
    us-east-1 = {
      maven_jenkins_ansible = "ami-063d43db0594b521b"
      nexus                 = "ami-063d43db0594b521b"
      sonarqube             = "ami-005fc0f236362e99f"
      prometheus            = "ami-005fc0f236362e99f"
      grafana               = "ami-005fc0f236362e99f"
      env                   = "ami-063d43db0594b521b"
    },
    us-east-2 = {
      maven_jenkins_ansible = "ami-0fae88c1e6794aa17"  
      nexus                 = "ami-0fae88c1e6794aa17"
      sonarqube             = "ami-00eb69d236edcfaf8"
      prometheus            = "ami-00eb69d236edcfaf8"
      grafana               = "ami-00eb69d236edcfaf8"
      env                   = "ami-0fae88c1e6794aa17"
    },
    us-west-1 = {
      maven_jenkins_ansible = "ami-05c65d8bb2e35991a"
      nexus                 = "ami-05c65d8bb2e35991a"
      sonarqube             = "ami-0819a8650d771b8be"
      prometheus            = "ami-0819a8650d771b8be"
      grafana               = "ami-0819a8650d771b8be"
      env                   = "ami-05c65d8bb2e35991a"

    },
    us-west-2 = {
      maven_jenkins_ansible = "ami-066a7fbea5161f451"
      nexus                 = "ami-066a7fbea5161f451"
      sonarqube             = "ami-0b8c6b923777519db"
      prometheus            = "ami-0b8c6b923777519db"
      grafana               = "ami-0b8c6b923777519db"
      env                   = "ami-066a7fbea5161f451"
    }
  }
}

# Instances types to be used

variable "InstanceType" {
  type        = map(string)
  description = "# Instances types to be used on the JavaApp Project"

  default = {
    maven_jenkins_ansible = "t2.large"
    nexus                 = "t2.medium"
    sonarqube             = "t2.medium"
    prometheus            = "t2.micro"
    env                   = "t2.micro"
    grafana               = "t2.micro"
  }
}

# Server's name to be displayed
variable "ServerNames" {
  type        = map(string)
  description = "Server's name for the JavaApp Project"

  default = {
    maven_jenkins_ansible = "Maven_jenkins_ansible"
    nexus                 = "Nexus"
    sonarqube             = "Sonarqube"
    prometheus            = "Prometheus"
    grafana               = "Grafana"
  }
}

# EC2 instances for Environment (env)
variable "instance_count" {
  description = "Number of EC2 instances for Env"
  type        = number
  default     = 3
}

variable "instance_names" {
  description = "List of EC2 instance names for Env"
  type        = list(string)
  default     = ["Dev-Env", "Stage-Env", "Prod-Env"]
}

variable "EC2_iam_role" {
  type        = string
  description = "EC2 IAM role to be used"
  default = "Ec2AdminRole"
}


variable "Key_Pair_Name" {
  type        = string
  description = "Your key pair file name"
  default = "id_rsa"
}
