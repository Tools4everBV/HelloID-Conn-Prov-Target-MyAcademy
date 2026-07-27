################################################################
# HelloID-Conn-Prov-Target-{connectorName}-SubPermissions-Group
# PowerShell V2
################################################################

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Script Mapping lookup values
# Lookup values which are used in the mapping to determine the subPermissions
$PrimaryLookupKey = { $_.Department.ExternalId } # Mandatory
$SecondaryLookupKey = { $_.Title.ExternalId } # Mandatory

#region functions
function Resolve-{connectorName}Error {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object]
        $ErrorObject
    )
    process {
        $httpErrorObj = [PSCustomObject]@{
            ScriptLineNumber = $ErrorObject.InvocationInfo.ScriptLineNumber
            Line             = $ErrorObject.InvocationInfo.Line
            ErrorDetails     = $ErrorObject.Exception.Message
            FriendlyMessage  = $ErrorObject.Exception.Message
        }
        if (-not [string]::IsNullOrEmpty($ErrorObject.ErrorDetails.Message)) {
            $httpErrorObj.ErrorDetails = $ErrorObject.ErrorDetails.Message
        }
        elseif ($ErrorObject.Exception.GetType().FullName -eq 'System.Net.WebException') {
            if ($null -ne $ErrorObject.Exception.Response) {
                $streamReaderResponse = [System.IO.StreamReader]::new($ErrorObject.Exception.Response.GetResponseStream()).ReadToEnd()
                if (-not [string]::IsNullOrEmpty($streamReaderResponse)) {
                    $httpErrorObj.ErrorDetails = $streamReaderResponse
                }
            }
        }
        try {
            $errorDetailsObject = ($httpErrorObj.ErrorDetails | ConvertFrom-Json)
            # Make sure to inspect the error result object and add only the error message as a FriendlyMessage.
            # $httpErrorObj.FriendlyMessage = $errorDetailsObject.message
            $httpErrorObj.FriendlyMessage = $httpErrorObj.ErrorDetails # Temporarily assignment
        }
        catch {
            $httpErrorObj.FriendlyMessage = $httpErrorObj.ErrorDetails
            Write-Warning $_.Exception.Message
        }
        Write-Output $httpErrorObj
    }
}
#endregion

# Begin
try {
    # Verify if [accountReference] has a value
    if ([string]::IsNullOrEmpty($($actionContext.References.Account))) {
        throw 'The account reference could not be found'
    }

    Write-Information 'Verifying if a {connectorName} account exists'
    $correlatedAccount = 'userInfo'
    # $correlatedAccount = (Invoke-RestMethod @splatGetUserParams)

    if ($null -ne $correlatedAccount) {
        $lifecycleProcess = 'ManageSubPermissions'
    }
    else {
        $lifecycleProcess = 'NotFound'
    }

    switch ($lifecycleProcess) {
        'ManageSubPermissions' {
            # Collect current permissions
            $currentPermissions = @{}
            foreach ($permission in $actionContext.CurrentPermissions) {
                $currentPermissions[$permission.Reference.Id] = $permission.DisplayName
            }

            # Collect desired permissions
            $desiredPermissions = @{}
            if (-not($actionContext.Operation -eq 'revoke')) {
                foreach ($contract in $personContext.Person.Contracts) {
                    if ($contract.Context.InConditions -or ($actionContext.DryRun -eq $true)) {
                        $primaryValue = $contract | ForEach-Object $PrimaryLookupKey
                        $secondaryValue = $contract | ForEach-Object $SecondaryLookupKey
                        $mappedItem = @{
                            Name = "$($primaryValue):$($secondaryValue)"
                            Id   = "$($primaryValue):$($secondaryValue)"
                        }
                        $desiredPermissions[$mappedItem.Name] = $mappedItem.Id
                    }
                }
            }

            # Process desired permissions to grant
            foreach ($permission in $desiredPermissions.GetEnumerator()) {
                $outputContext.SubPermissions.Add([PSCustomObject]@{
                        DisplayName = $permission.Value
                        Reference   = [PSCustomObject]@{
                            Id = $permission.Name
                        }
                    })

                if (-not $currentPermissions.ContainsKey($permission.Name)) {
                    if (-not($actionContext.DryRun -eq $true)) {
                        # Write permission grant logic here
                    }

                    $outputContext.AuditLogs.Add([PSCustomObject]@{
                            Action  = 'GrantPermission'
                            Message = "Granted access to permission $($permission.Value)"
                            IsError = $false
                        })
                }
            }

            # Process current permissions to revoke
            $newCurrentPermissions = @{}
            foreach ($permission in $currentPermissions.GetEnumerator()) {
                if (-not $desiredPermissions.ContainsKey($permission.Name)) {
                    if (-not($actionContext.DryRun -eq $true)) {
                        # Write permission revoke logic here
                    }

                    $outputContext.AuditLogs.Add([PSCustomObject]@{
                            Action  = 'RevokePermission'
                            Message = "Revoked access to permission $($permission.Value)"
                            IsError = $false
                        })
                }
                else {
                    $newCurrentPermissions[$permission.Name] = $permission.Value
                }
            }

            # Process permissions to update
            if ($actionContext.Operation -eq 'update') {
                foreach ($permission in $newCurrentPermissions.GetEnumerator()) {
                    if (-not($actionContext.DryRun -eq $true)) {
                        # Write permission update logic here
                    }

                    $outputContext.AuditLogs.Add([PSCustomObject]@{
                            Action  = 'UpdatePermission'
                            Message = "Updated access to permission $($permission.Value)"
                            IsError = $false
                        })
                }
            }
            $outputContext.Success = $true
            break
        }

        'NotFound' {
            Write-Information "{connectorName} account: [$($actionContext.References.Account)] could not be found, indicating that it may have been deleted"
            $outputContext.Success = $false
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = "{connectorName} account: [$($actionContext.References.Account)] could not be found, indicating that it may have been deleted"
                    IsError = $true
                })
            break
        }
    }
}
catch {
    $outputContext.Success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-{connectorName}Error -ErrorObject $ex
        $auditMessage = "Could not manage {connectorName} permissions. Error: $($errorObj.FriendlyMessage)"
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    }
    else {
        $auditMessage = "Could not manage {connectorName} permissions. Error: $($_.Exception.Message)"
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditMessage
            IsError = $true
        })
}