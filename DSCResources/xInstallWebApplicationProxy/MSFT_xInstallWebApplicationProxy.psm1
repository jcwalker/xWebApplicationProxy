function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$FederationServiceName,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$FederationServiceTrustCredential
	)


    $SslCertificate = Get-WebApplicationProxySslCertificate | where hostname -eq $FederationServiceName | where PortNumber -eq 443


	
	$returnValue = @{
		CertificateThumbprint = $SslCertificate.CertificateHash
		FederationServiceName = $SslCertificate.HostName
		ForwardProxy = $null
		HttpsPort = $null
		TlsClientPort = $null
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[System.String]
		$CertificateThumbprint,

		[parameter(Mandatory = $true)]
		[System.String]
		$FederationServiceName,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$FederationServiceTrustCredential,

		[System.String]
		$ForwardProxy,

		[System.Int32]
		$HttpsPort,

		[System.Int32]
		$TlsClientPort
	)

    $InstallWap = Install-WebApplicationProxy @PSBoundParameters

    If($InstallWap.Status -eq 'Success')
    {
        Write-Verbose "WAP installation was successful"
    }
    Else
    {
        throw "WAP installation failed"
    }


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[System.String]
		$CertificateThumbprint,

		[parameter(Mandatory = $true)]
		[System.String]
		$FederationServiceName,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$FederationServiceTrustCredential,

		[System.String]
		$ForwardProxy,

		[System.Int32]
		$HttpsPort,

		[System.Int32]
		$TlsClientPort
	)

    $WepAppConfig = Get-WebApplicationProxyConfiguration

    If(!$WepAppConfig)
    {
        Write-Verbose "No Web Application Proxy Configuration found"
        return $false

    }


    #If code made it this far the configuration is in a desired state.
    return $true
}


Export-ModuleMember -Function *-TargetResource

