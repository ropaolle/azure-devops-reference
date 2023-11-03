# Info

## Todo

- Build docker file and push to Azure

## Azure

### Allow GitHub Actions to access the container registry

```sh
az acr update -n RopaOlleRegistry --admin-enabled true
```

## Add OIDC auth

- [Configure a Federated Credential to use OIDC based authentication](https://github.com/azure/login#configure-a-federated-credential-to-use-oidc-based-authentication)

1. Register a new app and add federated credentials
   - [Configure a federated identity credential on an app](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#github-actions)
2. Add below as secrets in GitHub (https://github.com/ropaolle/devops-dev/settings/secrets/actions)
   AZURE_CLIENT_ID: "b1ddc928-0fcb-448a-992d-4b74915db165" (from the registered app)  
   AZURE_TENANT_ID: "a5685ef0-e406-4a6a-a786-00d78b98b3b6"
   AZURE_SUBSCRIPTION_ID: "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
3. Create a managed identity and add Federated credentials (equal to the ones in step 1)
   - [Create a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity)
   - [Add federated credentials](https://portal.azure.com/#@ifarfargmail.onmicrosoft.com/resource/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/devops/providers/Microsoft.ManagedIdentity/userAssignedIdentities/github-actions/federatedcredentials)
4. Add the role Contributor to the new Managed identity
   - [add role](https://portal.azure.com/#@ifarfargmail.onmicrosoft.com/resource/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/devops/providers/Microsoft.ManagedIdentity/userAssignedIdentities/github-actions/azure_resources)

## LINKS

- [Best practices for app and infrastructure code repositories](https://devops.stackexchange.com/questions/12803/best-practices-for-app-and-infrastructure-code-repositories)
- [NextJS With Docker](https://github.com/vercel/next.js/tree/canary/examples/with-docker)

### Azure

- [Deploy static-rendered Next.js websites on Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/deploy-nextjs-static-export?tabs=github-actions)

### GitHub Actions

- OIDC
  - [Using OIDC with Terraform in GitHub Actions](https://colinsalmcorner.com/using-oidc-with-terraform-in-github-actions/)
- Azure
  - [Deploy to Azure](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-azure)
- Terraform
  - [Terraform and GitHub Actions](https://github.com/Azure-Samples/terraform-github-actions)
  - [Deploying Terraform in Azure using GitHub Actions Step by Step](https://gmusumeci.medium.com/deploying-terraform-in-azure-using-github-actions-step-by-step-bf8804b17711)
  - [Deploying infrastructure to Azure using Terraform and GitHub Actions](https://www.fpgmaas.com/blog/azure-terraform-github-actions)
  - [Azure Terraform CI/CD](https://dev.to/coleheard/github-actions-azure-terraform-cicd-15dj)
- Kubernetes
  - [Starter workflows](https://github.com/actions/starter-workflows/blob/main/deployments/azure-kubernetes-service-helm.yml)
  - [Deploying to Azure Kubernetes Service](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-azure/deploying-to-azure-kubernetes-service)

## Docker

```sh
docker image ls
docker build -t devops01 .
docker run -d -p 3000:3000 devops01 # http://localhost:3000/
```

## Install Docker on WSL2

- [Install](https://docs.docker.com/engine/install/ubuntu/)
- [As non-root](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
- [iptables-legacy](https://nickjanetakis.com/blog/install-docker-in-wsl-2-without-docker-desktop)

```sh
# Uninstall old versions
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install latest version
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Run as non-root
sudo groupadd docker
Add your user to the docker group.

# Enable networking
udo update-alternatives --config iptables # select 1 iptables-legacy ()

# Ensure the Docker Service Runs in WSL 2
sudo nano  ~/.profile
# Add this
# if grep -q "microsoft" /proc/version > /dev/null 2>&1; then
#     if service docker status 2>&1 | grep -q "is not running"; then
#         wsl.exe --distribution "${WSL_DISTRO_NAME}" --user root \
#             --exec /usr/sbin/service docker start > /dev/null 2>&1
#     fi
# fi

# Test
sudo docker run hello-world
ps aux | grep docker
```

## Content

![DevOps](./images/devops.webp)

- Plan (GitHub Projekts)
- Code (monorepo or individual repos)
  - App code
  - Infra code
- Build (GitHub Actions)
- Test (GitHub Actions)
- Release (GitHub Actions)
- Deploy (GitHub Actions)
- Operate (Azure)
- Minitor and log (Azure)
- Feedback (GitHub Issues)
