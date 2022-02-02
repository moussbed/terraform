#### Link 
- Link of Terraform provider : https://registry.terraform.io/browse/providers
- How to use AWS provider : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

#### Install provider locally
After have defined provider in your configuration file (main.tf) we need to install it because 
providers are not included in the Terraform download. We have many providers that's the reason.
Let's install the provider by this command 
```bash
   $ terraform init # See the provider defined in the main.tf file and install it
```
This command create .terraform directory which contains complet API to talk which AWS and (Resources and Data sources).

Notice: It works like npm which adds the node_modules directory which contains the dependencies after typing $ npm install 

#### Apply Configuration
After defined the resources, we can now apply it
```bash
   $ terraform apply 
```

#### Data sources
data let's us query data from existing resources. For example create a subnet from existing vpc

#### Remove resource(s)

```bash
 $ terraform destroy -target aws_subnet.dev-subnet-2 # In this case we are going to remove only one resource.
 $ terraform destroy # Delete all resources
```
But this approach doesn't good, because your our current state doesn't correspond which confile file. Always delete what you don't need and versionning it with version control like git. After it, play the following command 

```bash
   $ terraform apply 
```

#### Get difference between current and desired state
```bash
   $ terraform plan 
```

#### Apply without ask confirmation
```bash
   $ terraform apply -auto-approve
```

#### View the state of a resource 
```bash
  $ terraform state list
  $ terraform state show $(terraform state list)[0]
```

#### Passing the variable value

```bash
  $ terraform apply -var "subnet-cidr-block=10.0.30.0/24"
```
or create a terraform.tfvars and assign the values to our variables.
Terraform find automatically the values on it.

```bash
  $ terraform apply
```
or if we have many environments we can create many .tfvars files like (terrafom-dev.tfvars,terraform-staging.tfvars,terraform-prod.tfvars).
And now, we have to specific the var file 

```bash
  $ terraform apply -var-file terraform-dev.tfvars
```

#### Environment variables

Set environment variables that Terraform will pick up

```bash
  $ export AWS_ACCESS_KEY_ID=XXXXXX
  $ export AWS_SECRET_ACCESS_KEY=XXXXXX
```
Now do 

```bash
  $ terraform apply -var-file terraform-dev.tfvars
```
If we have already .aws/credentials directory in our environment it isn't necessary to export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables because Terraform know where to find these variables 

#### Set variable using TF environment variable
Define a custom variable environment. To do that we must to prefix our environment variable by TF_VAR
```bash
  $ export TF_VAR_availability_zone="us-east-2a"
```
and reference it in the variable which have name "availability_zone" in our TF configure file  



