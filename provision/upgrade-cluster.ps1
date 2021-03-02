param(
    [Parameter(Mandatory=$true)]
    [String]
    $RESOURCE_GROUP_NAME,
    [Parameter(Mandatory=$true)]
    [String]
    $AKS_CLUSTER_NAME,
    [Parameter(Mandatory=$true)]
    [String]
    $VERSION
)

if ($VERSION -eq "") {
    $VERSION = az aks get-versions `
        --location $REGION_NAME `
        --query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' `
        --output tsv
}

az aks upgrade `
    --resource-group $RESOURCE_GROUP_NAME `
    --name $AKS_CLUSTER_NAME `
    --kubernetes-version $VERSION `
    -y
