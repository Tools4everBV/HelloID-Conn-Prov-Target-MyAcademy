####################################################################
# HelloID-Conn-Prov-Target-{connectorName}-ImportSubPermissions-Group
# PowerShell V2
####################################################################

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Configure, must be the same as the values used in retrieve permissions
$permissionReference = 'permissionReference'
$permissionDisplayName = 'permissionDisplayName'

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

try {
    Write-Information 'Starting {connectorName} permission entitlement import'
    $importedPermissions = @(
        @{
            id          = 'Permission1'
            description = 'First permission'
            displayName = 'First permission'
            members     = @('1001', '1002', '1003')
        },
        @{
            id          = 'Permission2'
            description = 'Second permission'
            displayName = 'Second permission'
            members     = @('1004', '1005')
        }
    )

    # # Example to replace the placeholder code with:
    # $splatImportPermissionParams = @{
    #     Uri    = $actionContext.Configuration.BaseUrl
    #     Method = 'GET'
    # }

    # # Make sure pagination is implemented when available
    # $importedPermissions = Invoke-RestMethod @splatImportPermissionParams


    foreach ($importedPermission in $importedPermissions) {
        $permission = @{
            PermissionReference      = @{
                Reference = $permissionReference
            }
            Description              = $permissionDisplayName
            DisplayName              = $permissionDisplayName
            AccountReferences        = $null
            SubPermissionReference   = @{
                Id = $importedPermission.id
            }
            SubPermissionDisplayName = "$($importedPermission.displayName)"
        }

        # The code below splits a list of permission members into batches of 100
        # Each batch is assigned to $permission.AccountReferences and the permission object will be returned to HelloID for each batch
        # Ensure batching is based on the number of account references to prevent exceeding the maximum limit of 500 account references per batch
        $batchSize = 500
        for ($i = 0; $i -lt ($importedPermission.members | Measure-Object).Count; $i += $batchSize) {
            $permission.AccountReferences = $importedPermission.members[$i..([Math]::Min($i + $batchSize - 1, $importedPermission.members.Count - 1))]
            Write-Output $permission
        }
    }
    Write-Information '{connectorName} permission entitlement import completed'
}
catch {
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-{connectorName}Error -ErrorObject $ex
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
        Write-Error "Could not import {connectorName} permission entitlements. Error: $($errorObj.FriendlyMessage)"
    }
    else {
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
        Write-Error "Could not import {connectorName} permission entitlements. Error: $($ex.Exception.Message)"
    }
}