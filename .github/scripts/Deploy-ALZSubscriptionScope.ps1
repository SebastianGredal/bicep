param (
  [Parameter()]
  [String]$Name,

  [Parameter()]
  [String]$Location = "$($env:LOCATION)",

  [Parameter()]
  [String]$TemplateFile,

  [Parameter()]
  [String]$TemplateParameterFile,

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Parameters necessary for deployment
$DeploymentName = "$Name-{0}" -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])

# Create the deployment
if ($WhatIfEnabled) {
  Write-Output 'What-If deployment is enabled. Deployment will not be executed.'
  az deployment sub what-if --name $DeploymentName --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --verbose
}
else {
  Write-Output 'What-If deployment is disabled. Deployment will be executed.'
  az deployment sub create --name $DeploymentName --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --verbose
}