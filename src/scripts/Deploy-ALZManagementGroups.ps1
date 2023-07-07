[CmdletBinding()]
param (
    [Parameter()]
    [String]$Location = 'westeurope',
    [Parameter()]
    [String]$TemplateFile = '.\src\bicep\modules\managementGroups\managementGroups.bicep',
    [Parameter()]
    [String]$TemplateParameterFile = '.\src\bicep\modules\managementGroups\parameters\managementGroups.all.bicepparam'
)

# Parameters necessary for deployment
$inputObject = @{
    DeploymentName        = 'alz-MGDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
    Location              = $Location
    TemplateFile          = $TemplateFile
    TemplateParameterFile = $TemplateParameterFile
    Verbose               = $true
}

New-AzTenantDeployment @inputObject