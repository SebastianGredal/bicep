param (
  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TemplateFile = 'src\bicep\management-groups\management-groups.bicep',

  [Parameter()]
  [String]$TemplateParameterFile = 'src\bicep\management-groups\parameters\management-groups.all.bicepparam',

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Parameters necessary for deployment
$DeploymentName = 'alz-MGDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])

# Create the deployment
if ($WhatIfEnabled) {
  Write-Output 'What-If deployment is enabled. Deployment will not be executed.'
  az deployment tenant what-if --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --verbose
}
else {
  Write-Output 'What-If deployment is disabled. Deployment will be executed.'
  az deployment tenant create --name $DeploymentName --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --verbose
}