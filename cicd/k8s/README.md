## Continuous Integration (CI) via Kubernetes and Docker

This section of the repository contains the Kubernetes (K8S) configuration and supporting shell scripts to provision a K8S cluster and the resources and components required for a continuous integration (CI) environment upon which developers can begin to build, test and deploy to a continuous deployment (CD) pipeline.

#### Prerequisites

You will need to have an active account on AWS and authority to create and update resources. You will also need to install [Docker](http://docker.com/) and [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/).


#### Getting Started

I'm assuming you've already cloned this repository to your local machine. You must first create a K8S cluster upon which you will provision the various components and supporting resources.

To create the cluster, navigate to the /iac/cicd/k8s/cluster directory.  The configuration values for the cluster are set in the set-env-vars.sh file as shown below. The *REGION* value determines where the cluster will be hosted. Using the value below will create the cluster in the us-west-2 region on AWS. The *KOPS_BUCKET_NAME* is a valid AWS S3 bucket name that will be created and will contain the K8S cluster state. Note that the name must be a globally unique name. *KOPS_STATE_STORE* is the full name of the S3 bucket. *CLUSTER_NAME* is the full name of your cluster.

Please change these to match your needs.
  
    export REGION=us-west-2 # Oregon, USA
    export KOPS_BUCKET_NAME=my-uniquely-named-state-store # globally unique S3 bucket name
    export KOPS_STATE_STORE=s3://${KOPS_BUCKET_NAME} 
    export CLUSTER_NAME=my-cluster-prototype.mydomain.com # K8S cluster name

#### Deployment

Once you've edited the set-env-vars.sh file you must source it.

<pre><code>. ./set-env-vars.sh
</code></pre>

Next create the cluster by executing the create-aws-k8s-cluster.sh script.

<pre><code>
 ./create-aws-k8s-cluster.sh
 </code></pre>

You will get the following output (shorten here for simplicity) based on the values in the set-env-vars.sh file.

<pre><code>
An error occurred (BucketAlreadyOwnedByYou) when calling the CreateBucket operation: Your previous request to create the named bucket succeeded and you already own it.
I0311 07:41:29.917356    5090 create_cluster.go:517] Inferred --cloud=aws from zone "us-west-2a"
I0311 07:41:30.321671    5090 subnets.go:184] Assigned CIDR 172.20.32.0/19 to subnet us-west-2a
Previewing changes that will be made:

SSH public key must be specified when running with AWS (create with `kops create secret --name wjd-prototype.gov-cio.com sshpublickey admin -i ~/.ssh/id_rsa.pub`)
I0311 07:41:35.095800    5092 executor.go:103] Tasks: 0 done / 86 total; 44 can run
I0311 07:41:35.610151    5092 vfs_castore.go:729] Issuing new certificate: "etcd-peers-ca-main"
...
I0311 07:41:40.832086    5092 vfs_castore.go:729] Issuing new certificate: "master"
I0311 07:41:40.967457    5092 vfs_castore.go:729] Issuing new certificate: "kops"
I0311 07:41:45.638785    5092 vfs_castore.go:729] Issuing new certificate: "kube-scheduler"
I0311 07:41:46.318737    5092 executor.go:103] Tasks: 68 done / 86 total; 16 can run
I0311 07:41:47.782540    5092 executor.go:103] Tasks: 84 done / 86 total; 2 can run
I0311 07:41:48.590757    5092 executor.go:103] Tasks: 86 done / 86 total; 0 can run
I0311 07:41:48.590859    5092 dns.go:155] Pre-creating DNS records
I0311 07:41:49.195409    5092 update_cluster.go:294] Exporting kubecfg for cluster
kops has set your kubectl context to wjd-prototype.gov-cio.com

Cluster is starting.  It should be ready in a few minutes.

Suggestions:
 * validate cluster: kops validate cluster
 * list nodes: kubectl get nodes --show-labels
 * ssh to the master: ssh -i ~/.ssh/id_rsa admin@api.wjd-prototype.gov-cio.com
 * the admin user is specific to Debian. If not using Debian please use the appropriate user based on your OS.
 * read about installing addons at: https://github.com/kubernetes/kops/blob/master/docs/addons.md.
 </code></pre>

As the instructions indicate, you'll need to wait a few minutes (more like 10 to 15) while the cluster initializes. Run the "kops validate cluster" command until you receive the following, using the values from set-env-vars.sh:

<pre><code>
Using cluster from kubectl context: wjd-prototype.gov-cio.com

Validating cluster wjd-prototype.gov-cio.com

INSTANCE GROUPS
NAME			ROLE	MACHINETYPE	MIN	MAX	SUBNETS
master-us-west-2a	Master	m3.medium	1	1	us-west-2a
nodes			Node	t2.medium	2	2	us-west-2a

NODE STATUS
NAME						ROLE	READY
ip-172-20-51-67.us-west-2.compute.internal	node	True
ip-172-20-55-19.us-west-2.compute.internal	master	True
ip-172-20-61-164.us-west-2.compute.internal	node	True

Your cluster wjd-prototype.gov-cio.com is ready
</code></pre>

You are now able to provision the resources required for the CI environment. Navigate to the iac/cicd/k8s/configs directory and execute the deploy-resources.sh script. It will provision all of the resources including the services to access the various components. You should see the following output.

<pre><code>
 > ./deploy-resources.sh 
secret/postgres-pwd created
persistentvolume/pv0001 created
persistentvolumeclaim/claim-postgres created
deployment.extensions/sonar-postgres created
service/sonar-postgres created
deployment.apps/artifactory created
service/artifactory created
deployment.apps/gitlab created
service/gitlab created
persistentvolume/jenkins-volume created
persistentvolumeclaim/jenkins-volume-claim created
deployment.apps/jenkins-master-deployment created
service/jenkins created
deployment.apps/sonarqube created
service/sonar created
</code></pre>

Using kubectl, get a list of the services that have been created. Note that the "EXTERNAL-IP" values along with the port numbers where they are listing for requests. For example the *artifactory* service is at IP "a049e369e2ac446c1888d8336c435b9d-1669305739.us-west-2.elb.amazonaws.com" and port 3030. Enter a049e369e2ac446c1888d8336c435b9d-1669305739.us-west-2.elb.amazonaws.com:3030 into your browser to access the Artifactory instance. Note going forward that DNS entries will be added for stable, easier to use URLs such as http://governmentcio-ci/jenkins. 

<code><pre>
 > kubectl get svc
NAME             TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                        AGE
artifactory      LoadBalancer   100.69.69.107    a049e369e2ac446c1888d8336c435b9d-1669305739.us-west-2.elb.amazonaws.com   3030:32233/TCP                 13m
gitlab           LoadBalancer   100.65.113.161   aeaf75198ca194910953fb401586edcc-754161193.us-west-2.elb.amazonaws.com    9200:32581/TCP,443:31798/TCP   13m
jenkins          LoadBalancer   100.66.65.241    ad4da34f58fbe4b58a09403cd012c232-698934311.us-west-2.elb.amazonaws.com    8080:32374/TCP                 13m
kubernetes       ClusterIP      100.64.0.1       <none>                                                                    443/TCP                        25m
sonar            LoadBalancer   100.70.44.33     ab018ae25e42b49b781cd74cf845f4b1-627271502.us-west-2.elb.amazonaws.com    9000:30154/TCP                 13m
sonar-postgres   ClusterIP      100.68.55.162    <none>
</code></pre>

To remove the cluster and all provisioned resources navigate back to the /cluster directory and execute the ./destroy-aws-k8s-cluster.sh script.

<code><pre>
 > ./delete-aws-k8s-cluster.sh 
TYPE			NAME											ID
autoscaling-config	master-us-west-2a.masters.wjd-prototype.gov-cio.com-20200311114146			master-us-west-2a.masters.wjd-prototype.gov-cio.com-20200311114146
autoscaling-config	nodes.wjd-prototype.gov-cio.com-20200311114146						nodes.wjd-prototype.gov-cio.com-20200311114146
...
dhcp-options:dopt-04fe68299a6e902de	ok
Deleted kubectl config for wjd-prototype.gov-cio.com
Deleted cluster: "wjd-prototype.gov-cio.com"
</code></pre>

#### Built With

* [Kubernetes](https://kubernetes.io)
* [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Docker](http://docker.com/)

#### Contributing

Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us.

#### Versioning

The current version is 1.1.0 which can be accessed at [K8S MVP](https://github.governmentcio.com/GCIO/iac/releases/tag/v1.1.0).

#### Authors

* William Drew
* Jaroslaw Podsiadlo 

#### License

#### Acknowledgements


