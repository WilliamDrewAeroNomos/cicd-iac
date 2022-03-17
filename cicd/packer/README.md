
# Packer IaC

The scripts, templates and variable files in this directory are used to create the various AMIs for use by the following steps in the pipeline. In order to execute these scripts you will need to install the Packer binary. 

# Packer scripts to build the base AMIs for each CI/CD component

The scripts, templates and variable files in this directory are used by HashiCorp's tool Packer to create the various Amazon Machine Images (AMI)s that will be used by later steps in the overall workflow that creates the CI/CD pipeline. 

Each of these AMIs is built in a customized manner in order to include as much of the base capabilities in the image as possible. This allows for both a consistentcy across the images as well as a much faster load time for the tool which is using the image as its base.

In order to execute these scripts you will need to install the Packer binary. See https://www.packer.io/downloads.html for the binary for your specific environment and the installation and setup instructions.

Once Packer is installed and verified, clone the repository to your local machine from https://github.governmentcio.com/GCIO/iac.git and navigate to the iac/cicd/packer directory. From there modify the values in the variables.json file. Note that "source_ami" is the AMI that will be used as the base image for all customized images.

Each component has their individual build script using the naming convention <component>-build-image.sh. Executing the component build script, such as artifactory-build-image.sh which will create the AMI for that component. There is also the create-all-images.sh helper script which will create all the AMIs for each component.
  
The output of each build script is an AMI to be used as the base image for a specific component such as GitLab, Artifactory, Sonar. etc. Each AMI will be stored in the AMI section on AWS within the "region" as specified in the variables.json file. The naming convention for each AMI is `<component-name>`-ci-`<specific AMI size>`. For example, the AMI that will be the base for the GitLab component is gitlab-ci-t2-large.

Note that each AMI has the tag "ci-component-name" that is used by the Terraform configurations to retrieve the appropriate AMI on which to provision the respective component.

