param(
    [Parameter(Mandatory=$true)]
    [String]
    $AD_GROUP_ID,
    [Parameter(Mandatory=$true)]
    [String]
    $RESOURCE_GROUP_NAME,
    [Parameter(Mandatory=$true)]
    [String]
    $AKS_CLUSTER_NAME,
    [Parameter(Mandatory=$true)]
    [String]
    $LOG_ANALYTICS_NAME,
    [Parameter(Mandatory=$true)]
    [String]
    $ENVIRONMENT,
    [Parameter(Mandatory=$true)]
    [String]
    $APP_CODE
)

$AD_GROUP_NAME = az ad group show `
    -g $AD_GROUP_ID `
    --query "displayName" `
    -o tsv

$RESOURCE_GROUP_ID = az group show `
    --name $RESOURCE_GROUP_NAME `
    --query "id" `
    -o tsv

az tag create `
    --resource-id $RESOURCE_GROUP_ID `
    --tags `
        "Type=Group" `
        "Owner=$APP_CODE" `
        "Environment=$ENVIRONMENT" `
        "Team=$AD_GROUP_NAME"

for ($i = 0; $i -lt 10; $i++) {

    [string[]]$WORKSPACES = az monitor log-analytics workspace list `
        -g $RESOURCE_GROUP_NAME `
        --query "[].name" `
        -o tsv

    if ($null -ne $WORKSPACES -and $WORKSPACES.Contains($LOG_ANALYTICS_NAME)) {

        $LOG_ANALYTICS_ID = az monitor log-analytics workspace show `
            --resource-group $RESOURCE_GROUP_NAME `
            --workspace-name $LOG_ANALYTICS_NAME `
            --query "id" `
            -o tsv

        az tag create `
            --resource-id $LOG_ANALYTICS_ID `
            --tags `
                "Type=Monitor" `
                "Owner=$APP_CODE" `
                "Environment=$ENVIRONMENT" `
                "Team=$AD_GROUP_NAME"
        
        Break
    }

    Start-Sleep -Seconds 30
}

for ($i = 0; $i -lt 10; $i++) {

    [string[]]$CLUSTERS = az aks list `
        -g $RESOURCE_GROUP_NAME `
        --query "[].name" `
        -o tsv

    if ($null -ne $CLUSTERS -and $CLUSTERS.Contains($AKS_CLUSTER_NAME)) {
        $AKS_CLUSTER_ID = az aks show `
            --resource-group $RESOURCE_GROUP_NAME `
            --name $AKS_CLUSTER_NAME `
            --query "id" `
            -o tsv

        az tag create `
            --resource-id $AKS_CLUSTER_ID `
            --tags `
                "Type=Compute" `
                "Owner=$APP_CODE" `
                "Environment=$ENVIRONMENT" `
                "Team=$AD_GROUP_NAME"
        
        Break
    }

    Start-Sleep -Seconds 30
}