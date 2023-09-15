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
  $result = az deployment mg what-if --name $DeploymentName --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --verbose 2>&1
  if (!$?) {
    Write-Error -Message "$result"
  }
}
else {
  Write-Output 'What-If deployment is disabled. Deployment will be executed.'
  az deployment mg create --name $DeploymentName --resource-group $ResourceGroupName --template-file $TemplateFile --parameters $TemplateParameterFile --verbose 2>&1
  if (!$?) {
    Write-Error -Message "$result"
  }
}