ORG_NAME=$1
REPOSITORY_NAME=$2
BRANCH_NAME=$3
CLUSTER_FOLDER=$4

flux bootstrap github \
    --owner=$ORG_NAME \
    --repository=$REPOSITORY_NAME \
    --branch=$BRANCH_NAME \
    --path=./clusters/$CLUSTER_FOLDER \
    --verbose
