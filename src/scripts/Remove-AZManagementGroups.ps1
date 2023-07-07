$topLevelManagementGroup = 'MGT'
function Remove-Recursively {
    param (
        $name
    )
    $parent = Get-AzManagementGroup -GroupName $name -Expand -Recurse

    if ($null -ne $parent.Children) {
        foreach ($children in $parent.Children) {
            Remove-Recursively($children.Name)
        }
    }
    Remove-AzManagementGroup -InputObject $parent
}

Remove-Recursively -name $topLevelManagementGroup