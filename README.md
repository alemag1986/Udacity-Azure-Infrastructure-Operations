# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction

This projects creates a vm image based on a Packer template, and deploys a customizable, scalable web server in Azure using  a Terraform template.

### Getting Started

1. Get the zip file containing the files needed and this readme :)
2. Get the needed Dependencies described below
3. Follow the Instructions and get your infrastructure deployed in Azure

### Dependencies/Pre-Requisites

1. Create an [Azure Account](https://portal.azure.com) and get a **Subscription**
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)
5. Install PowerShell (version 5.1 or higher) and AZ module [info](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-4.7.0).
6. Configure a new AzADServicePrincipal for Packer image build
    ```
    Connect-AzAccount
    $sp = New-AzADServicePrincipal -DisplayName <<REPLACE WITH A NAME>>
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
    $UnsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    ```
    `Note: you will need this values for building packer image` 
    `Note: windows os needed to retreive the secret` 

### Instructions

#### Define a Policy 

1. Create a policy rules (like tagging_policy_rules.json)
2. Create a policy definition:
```
az policy definition create --name <<REPLACEME>> \
                              --description "<<REPLACE ME>>" \
                              --display-name <<REPLACE ME>> \
                              --mode Indexed \
                              --rules tagging_policy_rules.json 
```
3. Assign policy
```
az policy assignment create --display-name <<REPLACE ME>> \
                            --name <<REPLACE ME>> \
                            --policy <<REPLACE ME WITH POLICY ABOVE>> \
                            --scope "/subscriptions/<<your subscription id>>"
```

#### Building the VM Image

1. Create a Azure Resource Group for your image 
2. Using AzADServicePrincial results in Pre-Requisits complete SubscriptionId, ClientId/ApplicationId and ClientSecret in server-vars.json
3. In server.json replace the other variables with your own values. 
4. Run `packer build -var-file=server-vars.json server.json` to create your image

`Note: you will need the values in server.json for terraform variables - vars.tf`

#### Build your Infrastructure 

1. Go over `vars.tf` file and define and change your template variables accordingly.
   Each variable has a proper definition and default value. 
2. Init terraform, by running `terraform init`
3. Get Terraform plan, by running `terraform plan -out solution.plan`
4. Deploy you infrastructure, run `terraform apply`
5. Once you are done, run `terraform destroy` to clean the resources.


### Output

Once you execute all the steps, you will have the following:

- Defined Azure policies to meet your requirements in the Azure Cloud
- A VM Image that you can access and easy reuse in your future VM deployments
- A deployed and secured scalable web server in Azure with the following criteria:
  - vnet and subnets
  - a load balancer
  - a customizable number of VM based on packer Image
  - with ip access rules that don't allow traffic from internet