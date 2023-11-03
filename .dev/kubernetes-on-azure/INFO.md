# Info

?

## Länkar

- [Install kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

## Setup

- [Guthub actions](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-azure/deploying-to-azure-kubernetes-service)
- [Snabbstart K8s cluster](https://learn.microsoft.com/sv-se/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli)
- [Containerregister](https://learn.microsoft.com/sv-se/azure/container-registry/container-registry-get-started-portal?tabs=azure-cli)
- [Login with OIDC](https://github.com/azure/login#sample-workflow-that-uses-azure-login-action-using-oidc-to-run-az-cli-linux)

```sh
# Cloud Shell (does not work on Chrome, only Edge)
az aks get-credentials --resource-group DevOpsKubernetes --name DevOpsK8s
kubectl get nodes

# Create GitHub secret - https://github.com/Azure/login#configure-deployment-credentials
az ad sp create-for-rbac --name "DevOpsApp" --role contributor \
                        --scopes /subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/DevOpsKubernetes \
                        --json-auth

$ Option '--sdk-auth' has been deprecated and will be removed in a future release.
$ Creating 'contributor' role assignment under scope '/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/DevOpsKubernetes'
$ The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
$ {
$   "clientId": "82dc6ff1-11b3-41f2-a857-b0d074413008",
$   "clientSecret": <SECRET>,
$   "subscriptionId": "e19611d3-62cd-4569-99b9-10ba8d0f4e79",
$   "tenantId": "a5685ef0-e406-4a6a-a786-00d78b98b3b6",
$   ...
$ }

# Add secret to GitHub - https://github.com/ropaolle/devops-dev/settings/secrets/actions/new
# Name: AZURE_CREDENTIALS
# VALUE:
# {
#   "clientId": "82dc6ff1-11b3-41f2-a857-b0d074413008",
#   "clientSecret": <SECRET>,
#   "subscriptionId": "e19611d3-62cd-4569-99b9-10ba8d0f4e79",
#   "tenantId": "a5685ef0-e406-4a6a-a786-00d78b98b3b6",
#   ...
# }

```
