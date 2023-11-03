# Info

- [Video](https://www.youtube.com/watch?v=V53AHWun17s)
- [Files](https://github.com/morethancertified/terraform-azure/blob/main/main.tf)
- [registry.terraform.io](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

## Init

```sh
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy

# Show ip

```

## Add ssh key

```sh
ssh-keygen -t rsa
# Enter file in which to save the key (/home/olle/.ssh/id_rsa): /home/olle/.ssh/devops

ll ~/.ssh
# total 40
# drwxr-xr-x  2 olle olle 4096 okt 24 16:58 ./
# drwxr-x--- 18 olle olle 4096 okt 24 13:47 ../
# -rw-------  1 olle olle 2590 okt 24 16:58 devops
# -rw-r--r--  1 olle olle  565 okt 24 16:58 devops.pub


# Get ip
terraform state list
terraform state show azurerm_linux_virtual_machine.devops-vm | grep public_ip_address
#    public_ip_address                                      = "20.91.204.83"
#    public_ip_addresses

# Access
ssh -i ~/.ssh/devops adminuser@20.91.204.83

# VS Code access
# add to ~/.ssh/config
Host 20.91.204.83
  HostName 20.91.204.83
  User adminuser
  IdentityFile ~/ssh/devops

```

```sh


```

## Setup on WSL

- [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)

```sh
az account show
az account subscription show --subscription-id "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
```

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli)

```sh

az account set --subscription "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79"

{
  "appId": "Bitwarden/Azure",
  "displayName": "azure-cli-2023-10-24-11-41-54",
  "password": "Bitwarden/Azure",
  "tenant": "Bitwarden/Azure"
}

export ARM_CLIENT_ID="<APPID_VALUE>"
export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_VALUE>"
```

## Extras

```sh
nano ~/.bashrc
#  alias ll='ls -alF'
#  alias tf='terraform'
source ~/.bashrc
```
