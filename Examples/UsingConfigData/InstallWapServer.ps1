Configuration InstallWap
{

    param
    (
        [pscredential]$FedServiceTrustCred,
        [pscredential]$WapCertPW
    )

    Import-DscResource -ModuleName xWebApplicationProxy,xPfxCertificate

    Node $AllNodes.Where{$_.Role -eq 'Wap Server'}.NodeName
    {

        LocalConfigurationManager
        {
            CertificateId = $node.MofEncyptionCert
        }

        xImportPfxCertificate SSLCert
        {
            Thumbprint = $node.WapSSLCert
            FilePath = $node.WapSSLCertPath
            Exportable = $true
            Password = $WapCertPW
            CertStoreLocation = "Cert:\localmachine\My"
        }

        WindowsFeature Web-Application-Proxy
        {
            Name = 'Web-Application-Proxy'
            Ensure = 'Present'
            IncludeAllSubFeature = $true   
        }

        xInstallWebApplicationProxy Install
        {
            FederationServiceName = $node.FedServiceName
            CertificateThumbprint = $node.WapSSLCert
            FederationServiceTrustCredential = $FedServiceTrustCred
            DependsOn = '[WindowsFeature]Web-Application-Proxy','[xImportPfxCertificate]SSLCert'
        }
    }

}

$WapCertPW  = Get-Credential -Message "Enter the password that is used to secure the WAP SSL certificate"
$FedSrvCred = Get-Credential -Message "Enter credentials for an account that has permissions to manage the Federation Service"

$ConfigData = "$PSScriptRoot\InstallWap-ConfigData.psd1"
$OutPutPath = "C:\InstallWapServer"

InstallWap -FedServiceTrustCred $FedSrvCred -OutputPath $OutPutPath -ConfigurationData $ConfigData -WapCertPw $WapCertPW

Set-DscLocalConfigurationManager -Path $OutPutPath -Verbose
Start-DscConfiguration -Path $OutPutPath -Verbose -Wait -Force