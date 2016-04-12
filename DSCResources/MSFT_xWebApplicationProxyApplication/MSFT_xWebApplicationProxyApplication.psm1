function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    $WapApp = Get-WebApplicationProxyApplication -Name $Name

    If($WapApp)
    {
        $EnsureRslt = 'Present'
    }
    Else
    {
        $EnsureRslt = 'Absent'
    }

	
	$returnValue = @{
		Name = $WapApp.Name
		ADFSRelyingPartyName = $WapApp.ADFSRelyingPartyName
		BackendServerAuthenticationSPN = $WapApp.BackendServerAuthenticationSPN
		BackendServerCertificateValidation = $WapApp.BackendServerCertificateValidation
		BackendServerUrl = $WapApp.BackendServerUrl
		ClientCertificateAuthenticationBindingMode = $WapApp.ClientCertificateAuthenticationBindingMode
		ClientCertificatePreauthenticationThumbprint = $WapApp.ClientCertificatePreauthenticationThumbprint
		DisableTranslateUrlInRequestHeaders = $WapApp.DisableTranslateUrlInRequestHeaders
		DisableHttpOnlyCookieProtection = $WapApp.DisableHttpOnlyCookieProtection
		DisableTranslateUrlInResponseHeaders = $WapApp.DisableTranslateUrlInResponseHeaders
		ExternalCertificateThumbprint = $WapApp.ExternalCertificateThumbprint
		ExternalPreauthentication = $WapApp.ExternalPreauthentication
		ExternalUrl = $WapApp.ExternalUrl
		InactiveTransactionsTimeoutSec = $WapApp.InactiveTransactionsTimeoutSec
		UseOAuthAuthentication = $WapApp.UseOAuthAuthentication
		Ensure = EnsureRslt
	}

	$returnValue
	
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[System.String]
		$ADFSRelyingPartyName,

		[System.String]
		$BackendServerAuthenticationSPN,

		[ValidateSet("None","ValidateCertificate")]
		[System.String]
		$BackendServerCertificateValidation,

		[System.String]
		$BackendServerUrl,

		[ValidateSet("None","ValidateCertificate")]
		[System.String]
		$ClientCertificateAuthenticationBindingMode,

		[System.String]
		$ClientCertificatePreauthenticationThumbprint,

		[System.Boolean]
		$DisableTranslateUrlInRequestHeaders,

		[System.Boolean]
		$DisableHttpOnlyCookieProtection,

		[System.Boolean]
		$DisableTranslateUrlInResponseHeaders,

		[System.String]
		$ExternalCertificateThumbprint,

		[ValidateSet("ADFS","ClientCertificate","PassThrough")]
		[System.String]
		$ExternalPreauthentication,

		[System.String]
		$ExternalUrl,

		[System.UInt32]
		$InactiveTransactionsTimeoutSec,

		[System.Boolean]
		$UseOAuthAuthentication,

		[parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

    #Remove parameters that don't exist on *WebApplicationProxyApplication cmdlets

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Add('ErrorAction','Stop')

    $WapApp = Get-WebApplicationProxyApplication -Name $Name

    If($WapApp -and $Ensure -eq 'Present')
    {
        Write-Verbose "WebApplicationProxyApplication $Name found. Updating configuration."
        If($PSBoundParameters.ExternalPreauthentication -or $PSBoundParameters.ADFSRelyingPartyName)
        {
            Write-Verbose "Removing WebApplicationProxyApplication $Name to update ExternalPreauthentication and/or ADFSRelyingPartyName"
            Remove-WebApplicationProxyApplication -Name $Name
            Try
            {                
                Add-WebApplicationProxyApplication @PSBoundParameters
            }
            Catch
            {
                throw $_
            }
        }
        Else
        {
            $PSBoundParameters.Remove('ADFSRelyingPartyName') | Out-Null

            Set-WebApplicationProxyApplication @PSBoundParameters
        }

    }
    ElseIf(!$WapApp -and $Ensure -eq 'Present')
    {
        Write-Verbose "WebApplicationProxyApplication $Name not found. Creating WebApplicationProxyApplication."
        Try
        {
            Add-WebApplicationProxyApplication @PSBoundParameters
        }
        Catch
        {
            throw $_
        }
    }
    ElseIf($WapApp -and $Ensure -eq 'Absent')
    {
        Write-Verbose "Removing WebApplicationProxyApplication $Name"
        Remove-WebApplicationProxyApplication -Name $Name
    }
        
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[System.String]
		$ADFSRelyingPartyName,

		[System.String]
		$BackendServerAuthenticationSPN,

		[ValidateSet("None","ValidateCertificate")]
		[System.String]
		$BackendServerCertificateValidation,

		[System.String]
		$BackendServerUrl,

		[ValidateSet("None","ValidateCertificate")]
		[System.String]
		$ClientCertificateAuthenticationBindingMode,

		[System.String]
		$ClientCertificatePreauthenticationThumbprint,

		[System.Boolean]
		$DisableTranslateUrlInRequestHeaders,

		[System.Boolean]
		$DisableHttpOnlyCookieProtection,

		[System.Boolean]
		$DisableTranslateUrlInResponseHeaders,

		[System.String]
		$ExternalCertificateThumbprint,

		[ValidateSet("ADFS","ClientCertificate","PassThrough")]
		[System.String]
		$ExternalPreauthentication,

		[System.String]
		$ExternalUrl,

		[System.UInt32]
		$InactiveTransactionsTimeoutSec,

		[System.Boolean]
		$UseOAuthAuthentication,

		[parameter(Mandatory = $true)]
		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)        

        $WapApp = Get-WebApplicationProxyApplication -Name $Name

        If(!$WapApp -and $Ensure -eq 'Present')
        {
            Write-Warning "WebApplicationProxyApplication $Name Absent. Expected: Present"
            return $false
        }
        If($WapApp -and $Ensure -eq 'Absent')
        {
            Write-Warning "WebApplicationProxyApplication $Name Present. Expected : Absent"
            return $false
        }
        If($WapApp)
        {
            Write-Verbose "WebApplicationProxyApplication $Name found"

            If($PSBoundParameters.BackendServerAuthenticationSPN -and $PSBoundParameters.BackendServerAuthenticationSPN -ne $WapApp.BackendServerAuthenticationSPN)
            {
                Write-Verbose "BackendServerAuthenticationSPN Expected: $BackendServerAuthenticationSPN Actual: $($WapApp.BackendServerAuthenticationSPN)"
                return $false
            }
            If($PSBoundParameters.BackendServerCertificateValidation -and $PSBoundParameters.BackendServerCertificateValidation  -ne $WapApp.BackendServerCertificateValidation)
            {
                Write-Verbose "BackendServerCertificateValidation Expected: $BackendServerCertificateValidation  Actual: $($WapApp.BackendServerCertificateValidation)"
                return $false
            }
            If($PSBoundParameters.BackendServerUrl  -and $PSBoundParameters.BackendServerUrl   -ne $WapApp.BackendServerUrl)
            {
                Write-Verbose "BackendServerUrl  Expected: $BackendServerUrl Actual: $($WapApp.BackendServerUrl)"
                return $false
            }
            If($PSBoundParameters.ClientCertificateAuthenticationBindingMode -and $PSBoundParameters.ClientCertificateAuthenticationBindingMode -ne $WapApp.ClientCertificateAuthenticationBindingMode)
            {
                Write-Verbose "ClientCertificateAuthenticationBindingMode Expected: $ClientCertificateAuthenticationBindingMode Actual: $($WapApp.ClientCertificateAuthenticationBindingMode)"
                return $false
            }
            If($PSBoundParameters.ClientCertificatePreauthenticationThumbprint -and $PSBoundParameters.ClientCertificatePreauthenticationThumbprint -ne $WapApp.ClientCertificatePreauthenticationThumbprint)
            {
                Write-Verbose "ClientCertificatePreauthenticationThumbprint Expected: $ClientCertificatePreauthenticationThumbprint Actual: $($WapApp.ClientCertificatePreauthenticationThumbprint)"
                return $false
            }
            If($PSBoundParameters.DisableHttpOnlyCookieProtection -and $PSBoundParameters.DisableHttpOnlyCookieProtection -ne $WapApp.DisableHttpOnlyCookieProtection)
            {
                Write-Verbose "DisableHttpOnlyCookieProtection Expected: $DisableHttpOnlyCookieProtection Actual: $($WapApp.DisableHttpOnlyCookieProtection)"
                return $false
            }
            If($PSBoundParameters.DisableTranslateUrlInRequestHeaders -and $PSBoundParameters.DisableTranslateUrlInRequestHeaders -ne $WapApp.DisableTranslateUrlInRequestHeaders)
            {
                Write-Verbose "DisableTranslateUrlInRequestHeaders Expected: $DisableTranslateUrlInRequestHeaders Actual: $($WapApp.DisableTranslateUrlInRequestHeaders)"
                return $false
            }
            If($PSBoundParameters.DisableTranslateUrlInResponseHeaders -and $PSBoundParameters.DisableTranslateUrlInResponseHeaders -ne $WapApp.DisableTranslateUrlInResponseHeaders)
            {
                Write-Verbose "DisableTranslateUrlInResponseHeaders Expected: $DisableTranslateUrlInResponseHeaders Actual: $($WapApp.DisableTranslateUrlInResponseHeaders)"
                return $false
            }
            If($PSBoundParameters.ExternalCertificateThumbprint -and $PSBoundParameters.ExternalCertificateThumbprint -ne $WapApp.ExternalCertificateThumbprint)
            {
                Write-Verbose "ExternalCertificateThumbprint Expected: $ExternalCertificateThumbprint Actual: $($WapApp.ExternalCertificateThumbprint)"
                return $false
            }
            If($PSBoundParameters.ExternalUrl -and $PSBoundParameters.ExternalUrl -ne $WapApp.ExternalUrl)
            {
                Write-Verbose "ExternalUrl Expected: $ExternalUrl Actual: $($WapApp.ExternalUrl)"
                return $false
            }
            If($PSBoundParameters.InactiveTransactionsTimeoutSec -and $PSBoundParameters.InactiveTransactionsTimeoutSec -ne $WapApp.InactiveTransactionsTimeoutSec)
            {
                Write-Verbose "InactiveTransactionsTimeoutSec Expected: $InactiveTransactionsTimeoutSec Actual: $($WapApp.InactiveTransactionsTimeoutSec)"
                return $false
            }
            If($PSBoundParameters.UseOAuthAuthentication -and $PSBoundParameters.UseOAuthAuthentication -ne $WapApp.UseOAuthAuthentication)
            {
                Write-Verbose "UseOAuthAuthentication Expected: $UseOAuthAuthentication Actual: $($WapApp.UseOAuthAuthentication)"
                return $false
            }

            #If the code made it this far all settings are in a desired state
            return $true
        }
}


Export-ModuleMember -Function *-TargetResource

