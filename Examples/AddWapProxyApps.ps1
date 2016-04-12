Configuration AddWebApplicationProxyApplication
{
    Import-DscResource -ModuleName xWebApplicationProxy

    node 'localhost'
    {
        xWebApplicationProxyApplication OWA
        {
            Name = 'OWA'
            BackendServerUrl = "https://mail.fabrikam.com/owa/"
            ExternalCertificateThumbprint = '2C6A6926F05544C68B45EB75CD228D861320B46C'
            ExternalUrl = 'https://mail.fabrikam.com/owa/'
            ExternalPreAuthentication = 'ADFS'
            ADFSRelyingPartyName = 'Outlook Web App'
            Ensure = 'Present'
        }
        xWebApplicationProxyApplication ECP
        {
            Name = 'ECP'
            BackendServerUrl = "https://mail.fabrikam.com/ecp/"
            ExternalCertificateThumbprint = '2C6A6926F05544C68B45EB75CD228D861320B46C'
            ExternalUrl = 'https://mail.fabrikam.com/ecp/'
            ExternalPreAuthentication = 'ADFS'
            ADFSRelyingPartyName = 'Exchange Admin Center'
            Ensure = 'Present'
        }
    }
}

AddWebApplicationProxyApplication -OutputPath C:\WebAppProxyApp

Start-DscConfiguration -Path C:\WebAppProxyApp -Verbose -Wait -Force