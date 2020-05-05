[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SettingsFile = "Deploy.parameters.dev.json"
)
$ErrorActionPreference = "stop"
Set-Location $PSScriptRoot

$args=Get-Content -Path $SettingsFile | ConvertFrom-Json

$groupName = $args.groupName
$location = $args.location
$webappName = $args.webappname

$appServiceName = "$($groupName)AppService"


$group = (az group create --name $groupName --verbose --location $location) | ConvertFrom-Json
Write-Host $group.id

$appService = (az appservice plan create -g $group.name -n $appServiceName) | ConvertFrom-Json
Write-Host $appService.id

$webapp = (az webapp create --name $webappName `
                            --resource-group $group.name `
                            --plan $appService.name `
                            ) | ConvertFrom-Json

Write-Host $webapp.id

az webapp update --https-only true --name $webappName --resource-group $group.name
