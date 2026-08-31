#################################################
# HelloID-Conn-Prov-Target-MyAcademy-Create
# PowerShell V2
#################################################

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

#region functions
function Resolve-MyAcademyError {
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

function New-AuthorizationHeaders {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[[String], [String]]])]
    param(
        [parameter(Mandatory)]
        [string]
        $authorizationKey
    )
    try {    
        # Add the authorization header to the request
        Write-Verbose 'Adding Authorization headers'

        $headers = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $pair = '' + ":" + $authorizationKey
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
        $base64 = [System.Convert]::ToBase64String($bytes)
        $key = "Basic $base64"
        $headers = @{
            "authorization" = $Key
        } 

        Write-Output $headers  
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
#endregion

try {
    # Initial Assignments
    $outputContext.AccountReference = 'Currently not available'

    $splatHeaderParams = @{
        authorizationKey = $actionContext.Configuration.AuthorizationKey
    }
    $headers = New-AuthorizationHeaders @splatHeaderParams

    $lifecycleProcess = 'CreateAccount'

    # Process
    switch ($lifecycleProcess) {
        'CreateAccount' {
            $formattedObject = [PSCustomObject]@{}

            foreach ($property in $actionContext.Data.PSObject.Properties) {
                $newName = $property.Name -replace '_', ' '
                $formattedObject | Add-Member -MemberType NoteProperty -Name $newName -Value $property.Value
            }

            # Convert object to csv and make sure each line ends with a newline
            $body = ($formattedObject | ConvertTo-Csv -NoTypeInformation -Delimiter ',') -join "`r`n" 

            $splatCreateParams = @{
                Uri         = "$($actionContext.Configuration.BaseUrl)/contentHandler/usersCsv"
                Body        = $body
                Method      = "Post"
                ContentType = "text/plain; charset=utf-8"
                Headers     = $headers
            }

            if (-not($actionContext.DryRun -eq $true)) {
                Write-Information 'Creating and correlating MyAcademy account'
                $response = Invoke-RestMethod @splatCreateParams
                Write-Warning ($response)

                $outputContext.AccountReference = $actionContext.Data.UserID
            }
            else {
                Write-Information '[DryRun] Create and correlate MyAcademy account, will be executed during enforcement'
                Write-Information "[DryRun] Body: $body"
            }
            $auditLogMessage = "Create account was successful. AccountReference is: [$($outputContext.AccountReference)]"
            break
        }
    }

    $outputContext.success = $true
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Action  = $lifecycleProcess
            Message = $auditLogMessage
            IsError = $false
        })
}
catch {
    $outputContext.success = $false
    $ex = $PSItem
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException') -or
        $($ex.Exception.GetType().FullName -eq 'System.Net.WebException')) {
        $errorObj = Resolve-MyAcademyError -ErrorObject $ex
        $auditLogMessage = "Could not create or correlate MyAcademy account: [$($actionContext.References.Account)]. Error: $($errorObj.FriendlyMessage)"
        Write-Warning "Error at Line '$($errorObj.ScriptLineNumber)': $($errorObj.Line). Error: $($errorObj.ErrorDetails)"
    }
    else {
        $auditLogMessage = "Could not create or correlate MyAcademy account: [$($actionContext.References.Account)]. Error: $($ex.Exception.Message)"
        Write-Warning "Error at Line '$($ex.InvocationInfo.ScriptLineNumber)': $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
    }
    $outputContext.AuditLogs.Add([PSCustomObject]@{
            Message = $auditLogMessage
            IsError = $true
        })
}