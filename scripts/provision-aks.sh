# -------------------------------------------------
#   Provision an AKS Cluster
# -------------------------------------------------
#   This Script will create an Azure Kubernetes
#   Cluster with Active Directory enabled with
#   managed identity for easy integration with
#   other Azure services.
# -------------------------------------------------

RESOURCE_GROUP_NAME=$1
REGION_NAME=$2
VNET_NAME=$3
SUBNET_NAME=$4
AKS_CLUSTER_NAME=$5
LOG_ANALYTICS_NAME=$6
AD_GROUP_ID=$7
AD_TENANT_ID=$8
AKS_NETWORK_PLUGIN=azure
NODE_COUNT=2

az group create \
	--name $RESOURCE_GROUP_NAME \
	--location $REGION_NAME

az network vnet create \
	--resource-group $RESOURCE_GROUP_NAME \
	--location $REGION_NAME \
	--name $VNET_NAME \
	--address-prefixes 10.0.0.0/8 \
	--subnet-name $SUBNET_NAME \
	--subnet-prefixes 10.240.0.0/16

SUBNET_ID=$(az network vnet subnet show \
	--resource-group $RESOURCE_GROUP_NAME \
	--vnet-name $VNET_NAME \
	--name $SUBNET_NAME \
	--query id -o tsv)

VERSION=$(az aks get-versions \
	--location $REGION_NAME \
	--query 'orchestrators[?!isPreview] | [-1].orchestratorVersion' \
	--output tsv)

az monitor log-analytics workspace create \
	--resource-group $RESOURCE_GROUP_NAME \
	--workspace-name $LOG_ANALYTICS_NAME \
	--location $REGION_NAME

LOG_ANALYTICS_ID=$(az monitor log-analytics workspace show \
	--resource-group $RESOURCE_GROUP_NAME \
	--workspace-name $LOG_ANALYTICS_NAME \
	--query "id" \
	-o tsv)

az aks create \
	--resource-group $RESOURCE_GROUP_NAME \
	--name $AKS_CLUSTER_NAME \
	--vm-set-type VirtualMachineScaleSets \
	--node-count $NODE_COUNT \
	--node-vm-size "Standard_B2s" \
	--nodepool-name "initial" \
	--load-balancer-sku standard \
	--workspace-resource-id $LOG_ANALYTICS_ID \
	--enable-addons monitoring \
	--location $REGION_NAME \
	--kubernetes-version $VERSION \
	--network-plugin $AKS_NETWORK_PLUGIN \
	--vnet-subnet-id $SUBNET_ID \
	--service-cidr 10.2.0.0/24 \
	--dns-service-ip 10.2.0.10 \
	--docker-bridge-address 172.17.0.1/16 \
	--generate-ssh-keys \
	--enable-aad \
	--aad-admin-group-object-ids $AD_GROUP_ID \
	--aad-tenant-id $AD_TENANT_ID \
	--enable-managed-identity
