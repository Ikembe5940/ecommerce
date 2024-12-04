
![App Screenshot](https://jdd-githup-readme-files.s3.us-east-1.amazonaws.com/cicd_images/cicd_jenkins.png)


# **eCommerce Environment - CICD Project**

# Infrastructure deployment

1. **Create a GitHub Repository named `ecommerce` and push the code in this branch(main) to 
    your remote repository (your newly created repository).**
    - Go to GitHub ([github.com](http://github.com "github.com"))
    - Login to your GitHub Account
    - Create a Repository called **ecommerce**
    - Clone the Repository in the "Repository" directory/folder in your local
    - CD into the folder using any CLI (`% cd ecommerce`)
    - Checkout to infrastructure Branch (`% git checkout infrastructure`)
    - Update the **vars.tf** file to specify the Region and to provide the key pair name (`% vi vars.tf`)
    - Add the code to git, commit and push it to your upstream branch "main or master"
    - Confirm that the code exist on GitHub

2. **Deploy the infrastructure**
Use Terraform commands to deploy the infrastructure
- `% terraform init`
- `% terraform validate`
- `% terraform plan`
- `% terraform apply` 

3. **Test the deployment**

Use the ssh command to try to connect to the various instances using the Public IP address and the corresponding Port. 






## íº€ About Me
I'm a full stack developer...

[Done by @jddbetambo](jddmangan@gmail.com)

