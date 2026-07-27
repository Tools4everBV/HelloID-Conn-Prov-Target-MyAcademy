##########################################################
# HelloID-Conn-Prov-Target-{connectorName}-Resources-Group
# PowerShell V2
##########################################################

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

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
    Write-Information "Creating [$($resourceContext.SourceData.Count)] resources"
    $outputContext.Success = $true
    foreach ($resource in $resourceContext.SourceData) {
        try {
            <# Resource creation preview uses a timeout of 30 seconds while actual run has timeout of 10 minutes #>

            # If resource does not exist
            if ($True) {
                # Make sure to test with special characters and if needed; add utf8 encoding.
                if (-not ($actionContext.DryRun -eq $True)) {
                    Write-Information "Create [$($resource)] {connectorName} resource"
                    # < Write resource creation logic here >

                }
                else {
                    Write-Information "[DryRun] Create {connectorName} [$($resource)] resource, will be executed during enforcement"
                }

                $outputContext.AuditLogs.Add([PSCustomObject]@{
                        Action  = 'CreateResource'
                        Message = "Created resource: [$($resource)]"
                        IsError = $false
                    })
            }

            # If resource requires Update
            if ($True) {
                if (-not ($actionContext.DryRun -eq $True)) {
                    Write-Information "Update [$($resource)] {connectorName} resource"
                    # < Write resource update logic here >

                }
                else {
                    Write-Information "[DryRun] Update {connectorName} [$($resource)] resource, will be executed during enforcement"
                }

                $outputContext.AuditLogs.Add([PSCustomObject]@{
                        Action  = 'UpdateResource'
                        Message = "Updated resource: [$($resource)]"
                        IsError = $false
                    })
            }
        }
        catch {
            $outputContext.Success = $false
            $ex = $PSItem
            if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
                $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
                $errorObj = Resolve-{connectorName}Error -ErrorObject $ex
                $auditLogMessage = "Could not create {connectorName} resource. Error: $($errorObj.FriendlyMessage)"
                Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
            }
            else {
                $auditLogMessage = "Could not create {connectorName} resource. Error: $($ex.Exception.Message)"
                Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
            }
            $outputContext.AuditLogs.Add([PSCustomObject]@{
                    Message = $auditLogMessage
                    IsError = $true
                })
        }
    }
}
catch {
    $outputContext.Success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-{connectorName}Error -ErrorObject $ex
        $auditLogMessage = "Could not create {connectorName} resource. Error: $($errorObj.FriendlyMessage)"
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    }
    else {
        $auditLogMessage = "Could not create {connectorName} resource. Error: $($ex.Exception.Message)"
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditLogMessage
            IsError = $true
        })
}
