param (
  [Parameter()]
  [String]$Name,

  [Parameter()]
  [String]$ResourceGroupName,

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
  $result = az deployment group what-if --name $DeploymentName --resource-group $ResourceGroupName --template-file $TemplateFile --parameters $TemplateParameterFile --verbose 2>&1
  if (!$?) {
    Write-Error -Message "$result"
  }
}
else {
  Write-Output 'What-If deployment is disabled. Deployment will be executed.'
  $result = az deployment group create --name $DeploymentName --resource-group $ResourceGroupName --template-file $TemplateFile --parameters $TemplateParameterFile --verbose 2>&1
  if (!$?) {
    Write-Error -Message "$result"
  }
}