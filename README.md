
# **Java WebApp Deployment**

# Pre-requisites
1. Make sure that all the infrastructure is deployed and running
- Jenkins server
- Sonarqube server
- Nexus server

2. If not yet done, clone the github Repository of ecommerce project in the directory/folder in your local computer. If the github repository is already cloned, just execute the git checkout command.
```bash
git clone <your_github_repository_url>
``` 
```bash
cd ecommerce
``` 
```bash
git checkout application
```

# Configuration of Sonarqube Server
1. Log into sonarqube server GUI
2. Create a new project named **java-webapp**
3. Generate the token for the project 
4. Select **Java** as the project programming type
5. Select **Maven** as the builder
6. Copy the maven command for sonarqube for the analysis and keep it
```bash
mvn sonar:sonar \
  -Dsonar.projectKey=java-webapp \
  -Dsonar.host.url=http://<sonarqube_public_ip>:9000 \
  -Dsonar.login=<token_generated>
```

# Configuration of Maven server
1. Log into Maven Server GUI
2. Go to Server **Administration and Configuration**
3. Go to Repositories and click on **Create Repository**
4. Select **Maven2 (group)** as recipe
5. Enter the name of the project parameters: 
- **Name**: maven_project
- **Version policy**: Release
- **Layout policy**: Strict
- **Content Disposition**: inline
6. Under Group section, select all available **Member repositories**
7. Click on **Create repository**

# Connection on Jenkins Server 
**You must skip this phase if it is already done before.**
1. Use your web browser to connect to your Jenkins Public IP Address on the port 8080. Your will be prompted to enter the default admin password
```bash 
http://<jenkins_public_ip>:8080/ 
```
2. SSH  into your Jenkins instance using your Shell (GitBash or your Mac Terminal)
```bash 
ssh -i <path_to_your_private_key> ec2-user@<jenkins_public_ip> 
```
3. Run the command below to get the Administrator Password 
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
4. Copy the password from the CLI and paste it on Jenkins GUI at the login page. Then provide the new login credentials. 
- **Username**: admin
- **Password**: admin
- **Name**: Jenkins Admin
- **Email**: admin
- Continue and Start using Jenkins

# Installation of Plugins for Java App
1. Use your web browser to connect to your Jenkins Public IP Address on the port 8080.
```bash 
http://<jenkins_public_ip>:8080/ 
```
2. Go to **Dashboard > Manage Jenkins > Plugins**
3. On left side click on **Available** then Search and install these plugins
- SonnarQube Scanner
- Maven Integration
- Pipeline Maven Integration
- Maven Release Plug-In

# Configuration of Sonarqube on Jenkins Server
1. Navigate to **Dashboard > Manage Jenkins > System**
2. Scroll down to the **SonarQube servers** section and click on **Add SonarQube**. 
3. Provide properties for the SonarQube plugin
- **Name**: localSonarqube
- **Server URL**: 
```bash
http://<sonarqube_private_ip>:9000
```
- **Server authentication token**: 
    - Click on **Add** to create credentials for Sonarqube
    - On the new page, you can set up SonarQube credentials
    - Choose the appropriate domain.
    - Click **Add Credentials**.
    - Select the credential type **Secret text** for tokens 
    - Select **Username with password** for username/password field.
    - Enter the credential details: **<token_generated_on_sonarqube_server>** 
- Provide an ID : **sonarqube-login**
- Provide a description
- Save the credentials.
4. Make sure that the sonarqube credential is selected for this Sonarqube plugin configuration on Jenkins.

# Configuration of Maven server on Jenkins Server
Make sure that the plugin is already installed.
1. Navigate to **Jenkins -> Manage Jenkins -> Tools**
2. Search for **Maven Installations** section
3. Provide the properties of Maven Installation 
- **Name**: localMaven
- Check the button **Install automatically** and select the **Maven version** you want to use
4. Click on **Save**

# Configuration of java (JDK) on Jenkins Server
1. Make sure that the plugin is already installed.
2. Navigate to **Jenkins -> Manage Jenkins -> Tools**
3. Search for **JDK Installations** section
4. Provide the properties of your JDK Installation 
- **Name**: localJDK
- Check the button **Install automatically**
- **Download URL for binaries archive**
```bash
https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz 
```
- **Subdirectory of extracted archives**: jdk-11.0.1

# Setting of Nexus security on Jenkins Server
1. Make sure that the package apache-maven is intalled on the Jenkins Server. This normally is done through the user data provided during the deployment of the infrastructure.
```bash
dnf list installed | grep apache-maven
```
or
```bash
sudo apt list --installed | grep apache-maven
```
2. SSH into Jenkins Server 
```bash 
ssh -i <path_to_your_private_key> ec2-user@<jenkins_public_ip> 
```
3. Use maven command to generate an encrypted nexus user password for service communication. Take this as **serv_passwd** to be used on step **8**.
```bash 
sudo mvn -emp admin 
```
4. Use maven command to generate an encrypted nexus user password for nexus admin connection. Take this as **admin_passwd** to be used on step **9**.
```bash 
sudo mvn -ep admin 
```
5. Change the user to root
```bash 
sudo su 
```
6. CD to the root directory
```bash 
cd /root 
```
7. Create a folder .m2 in the root filesystem (/root)
```bash 
mkdir .m2/ 
```
8. Create a file **settings-security.xml** in the folder .m2/
```bash 
vi .m2/settings-security.xml 
```
Switch to the Insert mode and paste de below
```bash
<?xml version="1.0"?>
<settingsSecurity>
    <master>{serv_passwd}</master>
</settingsSecurity>
```
Replace **serv_passwd** par the password generated above.
Save and exit

9. Create a file settings.xml in the folder .m2/
```bash 
vi .m2/settings.xml 
```
Switch to the Insert mode and paste de below

```bash
<?xml version="1.0"?>
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>/var/lib/jenkins/.m2/repository</localRepository>
<servers>
   <server>
        <id>nexus</id>
        <username>admin</username>
        <password>{admin_passwd}</password>
    </server>
</servers>
<mirrors>
    <mirror>
      <id>nexus</id>
      <name>nexus</name>
      <url>http://@Nexus_Private:8081/repository/maven_project/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
```
Replace **@Nexus_Private** by your Nexus private IP address.

Save and exit

10. Move the directory .m2/ to the directory jenkins home directory /var/lib/jenkins/
```bash 
mv .m2/ /var/lib/jenkins/.m2 
```

11. Change ownership of the 2 files created
```bash
chown jenkins:jenkins /var/lib/jenkins/.m2/settings.xml
```

```bash
chown jenkins:jenkins /var/lib/jenkins/.m2/settings-security.xml
```

12. Change permissions of the 2 files created
```bash
chmod 755 /var/lib/jenkins/.m2/settings-security.xml
```

```bash
chmod 755 /var/lib/jenkins/.m2/settings.xml
```

# Editing the pom.xml file
1. Go to your local folder on your computer (see Pre-requisites section)
2. Open the **pom.xml** file and Update the Nexus Private IP Address
3. Push to the remote repository
```bash 
git add pom.xml
```
```bash 
git commit -m "Updating pom.xml file"
```
```bash 
git push
```

# Testing the pipeline

