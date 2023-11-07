# Info

## Azure


```sh
# login via cli
az account subscription show --subscription-id "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
az login
```

## Add OIDC auth

- [Configure a Federated Credential to use OIDC based authentication](https://github.com/azure/login#configure-a-federated-credential-to-use-oidc-based-authentication)

1. Register a new app and add federated credentials
   - [Configure a federated identity credential on an app](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#github-actions)
2. Add below as secrets in GitHub (https://github.com/ropaolle/devops-dev/settings/secrets/actions)
   AZURE_MANAGED_IDENTITIE_CLIENT_ID: "b1ddc928-0fcb-448a-992d-4b74915db165" (from the registered app)  
   AZURE_TENANT_ID: "a5685ef0-e406-4a6a-a786-00d78b98b3b6"
   AZURE_SUBSCRIPTION_ID: "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
3. Create a managed identity and add Federated credentials (equal to the ones in step 1)
   - [Create a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity)
   - [Add federated credentials](https://portal.azure.com/#@ifarfargmail.onmicrosoft.com/resource/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/devops/providers/Microsoft.ManagedIdentity/userAssignedIdentities/github-actions/federatedcredentials)
4. Add the role Contributor to the new Managed identity
   - [add role](https://portal.azure.com/#@ifarfargmail.onmicrosoft.com/resource/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/devops/providers/Microsoft.ManagedIdentity/userAssignedIdentities/github-actions/azure_resources)

```sh
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79"

# Create GitHub secret - https://github.com/Azure/login#configure-deployment-credentials
az ad sp create-for-rbac --name "DevOpsApp" --role contributor \
                        --scopes /subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/DevOpsKubernetes \
                        --json-auth
```
