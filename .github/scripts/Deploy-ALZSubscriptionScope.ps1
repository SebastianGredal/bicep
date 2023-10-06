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
  [String]$DenySettingsExcludedPrincipals = (az ad signed-in-user show | ConvertFrom-Json).id,

  [Parameter()]
  [ValidateSet('denyDelete', 'denyWriteAndDelete', 'none')]
  [String]$DenySettingsMode,

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

# Parameters necessary for deployment
$DeploymentName = "$Name-{0}" -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])

# Create the deployment
if ($WhatIfEnabled) {
  Write-Output 'What-If deployment is enabled. Deployment will not be executed.'
  $result = az deployment sub what-if --name $DeploymentName --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --verbose 2>&1
  if (!$?) {
    Write-Error -Message "$result"
  }
  $result
}
else {
  Write-Output 'What-If deployment is disabled. Deployment will be executed.'
  $result = az stack sub create --name $Name --location $Location --template-file $TemplateFile --parameters $TemplateParameterFile --deny-settings-excluded-principals $DenySettingsExcludedPrincipals --deny-settings-mode $DenySettingsMode --delete-all --yes --verbose 2>&1
  if (!$?) {
    Write-Error -Message "$result"
  }
  $result
}