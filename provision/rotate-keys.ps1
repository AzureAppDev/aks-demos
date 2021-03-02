param(
    [Parameter(Mandatory=$true)]
    [String]
    $RESOURCE_GROUP_NAME,
    [Parameter(Mandatory=$true)]
    [String]
    $AKS_CLUSTER_NAME
)

az aks rotate-certs `
    --resource-group $RESOURCE_GROUP_NAME `
    --name $AKS_CLUSTER_NAME `
    -y

