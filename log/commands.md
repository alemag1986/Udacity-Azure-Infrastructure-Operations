## 3. Define a Policy


```
  az policy definition create --name tagging-policy-definition \
                              --description "Indexed resources in subscription must have tags" \
                              --display-name tagging-policy \
                              --mode Indexed \
                              --rules tagging_policy_rules.json \
  {
    "description": "Indexed resources in subscription must have tags",
    "displayName": "tagging-policy",
    "id": "/subscriptions/<<replace-subscriptionId>>/providers/Microsoft.Authorization/policyDefinitions/tagging-policy-definition",
    "metadata": {
      "createdBy": "498675c4-4cb7-4645-b10d-16179fe6f5d2",
      "createdOn": "2020-09-18T05:17:22.1865171Z",
      "updatedBy": null,
      "updatedOn": null
    },
    "mode": "Indexed",
    "name": "tagging-policy-definition",
    "parameters": null,
    "policyRule": {
      "if": {
        "exists": "false",
        "field": "tags"
      },
      "then": {
        "effect": "deny"
      }
    },
    "policyType": "Custom",
    "type": "Microsoft.Authorization/policyDefinitions"
  }
```

```
az policy assignment create --display-name tagging-policy \
                            --name tagging-policy \
                            --policy tagging-policy-definition \
                            --scope "/subscriptions/<<replace-subscriptionId>>"
```

```
az policy assignment list --query "[?name=='tagging-policy']"
```


## 6. Deploying Your Infrastructure

- Run packer build

Get Powershell (local) 
brew cask install powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
Connect-AzAccount
$sp = New-AzADServicePrincipal -DisplayName UdacityPackerSP001
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
$UnsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

export ARM_SUBSCRIPTION_ID=<<replace-subscriptionId>>
export ARM_CLIENT_ID=<<replace>
export ARM_CLIENT_SECRET=<<replace>

```
packer build -var-file=server-vars.json server.json


==> Wait completed after 7 minutes 36 seconds
==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:
OSType: Linux
ManagedImageResourceGroupName: images-rg
ManagedImageName: ubuntu-udacity-project
ManagedImageId: /subscriptions/<<replace-subscriptionId>>/resourceGroups/images-rg/providers/Microsoft.Compute/images/ubuntu-udacity-project
ManagedImageLocation: East US 2
```

- Run terraform plan

```
terraform init
terraform plan -out solution.plan
terraform apply
terraform destroy
```