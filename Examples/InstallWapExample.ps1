Configuration InstallWap
{

    param
    (
        [pscredential]$FedServiceTrustCred
    )

    Import-DscResource -ModuleName xWebApplicationProxy

    Node $AllNodes.Where{$_.Role -eq 'Wap Server'}.NodeName
    {

        WindowsFeature Web-Application-Proxy
        {
            Name = 'Web-Application-Proxy'
            Ensure = 'Present'
            IncludeAllSubFeature = $true   
        }

        xInstallWebApplicationProxy Install
        {
            FederationServiceName = 'sts.fabrikam.com'
            CertificateThumbprint = '933D8ACDD49CEF529EB159504C4095575E3496BB'
            FederationServiceTrustCredential = $FedServiceTrustCred
            DependsOn = '[WindowsFeature]Web-Application-Proxy'
        }
    }

}


$ConfigData = @{
    AllNodes = @(
        @{
            NodeName="*"
            PSDscAllowPlainTextPassword = $true            
         }
       @{
            NodeName = 'Wap1.fabrikam.com'
            Role = 'Wap Server'
            OwaUrl = "https://mail.fabrikam.com/owa"

        }
    )
}


$FedSrvCred = Get-Credential -Message "Enter credential that has admin rights on ADFS server"

InstallWap -FedServiceTrustCred $FedSrvCred -OutputPath c:\dsc -ConfigurationData $ConfigData

Start-DscConfiguration -Path c:\dsc -Verbose -Wait -Force