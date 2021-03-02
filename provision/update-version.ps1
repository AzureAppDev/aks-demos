param(
    [Parameter(Mandatory=$true)]
    [String]
    $KEY_VAULT_NAME="kv-nuo-env0-dev",
    [Parameter(Mandatory=$true)]
    [String]
    $PROVISION_NUMBER_SECRET_NAME="AKS-NUO-DEV",
    [String]
    $INCREMENT="no"
)

[String]$PROVISION_NUMBER_SECRET_NAME = $PROVISION_NUMBER_SECRET_NAME.ToUpper()

[Int32]$SECRET_VALUE = az keyvault secret show `
    --vault-name $KEY_VAULT_NAME `
    --name $PROVISION_NUMBER_SECRET_NAME `
    --query "value" `
    -o tsv

if ($INCREMENT -eq "yes") {
    [Int32]$SECRET_VALUE = $SECRET_VALUE + 1

    az keyvault secret set `
        --vault-name $KEY_VAULT_NAME `
        --name $PROVISION_NUMBER_SECRET_NAME `
        --value $SECRET_VALUE
}

Write-Output "::set-output name=provision_number::$SECRET_VALUE"

