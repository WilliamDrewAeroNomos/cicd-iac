# Configurations to build out a CI/CD pipeline via Terraform

The scripts, templates and variable files in this directory are used by HashiCorp's tool Terraform to provision the resources to create a fully functioning, ready-to-use CI/CD pipeline. This includes not only the user facing components (i.e. Sonar, Jenkins, etc.) but also the networking, security, load balancing, DNS entries and persistent stores.

The configurations that build the user facing components reference Amazon Machine Images (AMI)s that were created earlier by the Packer scripts contained in the Packer directory within this repository. Important note, those AMIs must be created *before* you apply these Terraform configurations.

In order to apply these configurations you must first have Terraform properly installed and configured. See https://www.terraform.io/intro/index.html for complete instructions based on your target platform.

Once you have Terraform installed and configured you can apply the Terraform configurations. Assuming you've already cloned the repository to build the required AMIs via the Packer scripts, navigate to the /iac/cicd/terraform directory. From there run terraform init which will pull down the necessary plugins. Then execute the create.sh script to start the provisioning. 

You will receive a prompt for var.JENKINS_PASSWORD. Enter any string greater than 6 characters and hit enter to proceed. Do the same for var.RDS_PASSWORD.

Multiple lines of output will appear showing the components that will be added with the apply. Enter 'yes' at the prompt and the provisioning will begin. This should take anywhere from 15 to 30 minutes, depending on your connection speed. Once it's completed, all the relevant connection points and URLs for each of the components will be displayed on the screen. The following is a representative example:

Outputs:

Artifactory_RDS_end_point = artifactorydb.crytlcp6wpza.us-east-1.rds.amazonaws.com:3306

Artifactory_URL = artifactory-ci.devgovcio.com

Dashboard_URL = dashboard-ci.devgovcio.com

GitLab_RDS_end_point = gitlabdbci.crytlcp6wpza.us-east-1.rds.amazonaws.com:5432

GitLab_URL = gitlab-ci.devgovcio.com

Jenkins_URL = jenkins-ci.devgovcio.com

Sonar_RDS_end_point = sonardbci.crytlcp6wpza.us-east-1.rds.amazonaws.com:5432

Sonar_URL = sonar-ci.devgovcio.com

artifactory-ami-id = ami-0591a86d089c04ede

dashboard-ami-id = ami-0ac342cd6cabf7c99

gitlab-ami-id = ami-0f62de64f726265c4

jenkins-ami-id = ami-03854637e62a80898

sonar-ami-id = ami-05ae4bae8b5faf335

From there you should be able to access the URLs presented on the screen and begin using the each of the components. The default URLs and credentials for each is as follows:

Artifactory_URL = artifactory-ci.devgovcio.com (admin/password)

GitLab_URL = gitlab-ci.devgovcio.com (go through “Register”)

Jenkins_URL = jenkins-ci.devgovcio.com (wdrew/password1234)

Sonar_URL = sonar-ci.devgovcio.com (admin/admin)

Dashboard_URL = dashboard-ci.devgovcio.com (create your own via Login->Sign Up)

