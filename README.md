
![App Screenshot](https://jdd-githup-readme-files.s3.us-east-1.amazonaws.com/cicd_images/cicd_jenkins.png)


# **Infrastructure deployment**

# Initial setup

Create a GitHub Repository named `ecommerce` and push the code in this branch(main) to 
    your remote repository (your newly created repository)
    
1. Go to GitHub ([github.com](http://github.com "github.com"))
2. Login to your GitHub Account
3. Create a Repository called **ecommerce**
4. Clone the Repository in the "Repository" directory/folder in your local
```bash
git clone <your_github_repository_url>
```
5. CD into the folder using any CLI 
```bash
cd ecommerce
```
6. Checkout into infrastructure Branch 
```bash
git checkout infrastructure
```
7. Update the **vars.tf** file to specify the Region and to provide the key pair name 
```bash
vi vars.tf
```
8. Add the code to git, commit and push it to your upstream branch "main or master"
```bash 
git add vars.tf
```
```bash 
git commit -m "Updating vars.tf file"
```
```bash 
git push
```

9. Confirm that the updates are taken into account in your GitHub project repository.

# Deployment of the infrastructure

Use Terraform commands to deploy the infrastructure
```bash 
terraform init
```
```bash 
terraform validate
```
```bash 
terraform plan
```
```bash 
terraform apply --auto-approve 
```

Use the ssh command to try to connect to the various instances using the Public IP address and the corresponding Port and make sure that the service is up and running.

# Jenkins Server Configuration
1. SSH to the Jenkins Server
```bash 
ssh -i <path_to_your_private_key> ec2user@<jenkins_public_ip> 
```
2. Update the admin password (for the first connection)
3. install the required plugins for infrastructure 
- Terraform 
- Slack notification (see below)
    - [Create a workspace](https://github.com/jjtechchampion/ecommerce/blob/main/1.Slack_Worksapce_Creation.md/)
    - [Create a channel](https://github.com/jjtechchampion/ecommerce/blob/main/2.Slack_Channel_Creation.md/)
    - [Configure slack notification in Jenkins](https://github.com/jjtechchampion/ecommerce/blob/main/3.Jenkins_Slack_Notification.md/)
- Email notification ([Email notification in Jenkins](https://github.com/jjtechchampion/ecommerce/blob/main/4.Jenkins_Email_Notification.md/))
4. Create a new item for the cicd pipeline
5. Use a jenkinsfile as pipeline script
6. Configure the jenkinsfile to use checkov for terraform code analysis
7. Parameterize the script to have 2 actions (**apply/destroy**)
8. Configure the script to trigger github
9. Configure webhook in the github repository

# Optimizing the Terraform code using checkov

1. Make sure that the Jenkins Configuration is done
2. Try to build the pipeline and make corrections required by checkov on **maint.tf**

**Note**
Checkov package is automatically installed with Jenkins as user data scripts. So, during the building of your pipeline, make sure that Jenkins can call the checkov command for code analysis.


# Updating the github repository
Once you made all modifications and you can build your pipeline without any error, you can now save all to your github repository.
```bash 
git add main.tf jenkinsfile
```
```bash 
git commit -m "Updating files main.tf and jenkinsfile"
```
```bash 
git push
```

If the webhook on github and pipeline are well configured, a build is automatically triggered and you receive notifications in slack and gmail as well.
## íº€ About Me
I'm a full stack developer...

[Done by @jddbetambo](jddmangan@gmail.com)

