@{
    AllNodes = @(
        @{
            NodeName="*"           
         }
       @{
            NodeName         = 'Wap1.fabrikam.com'

            CertificateFile  = 'C:\Certs\DSCDemo.cer'

            MofEncyptionCert = '8CA0375700FCBE356FD4D045664D98F779622958'

            WapSSLCert       = '5B348834D00D5D09BDEA9C71432FDEAE35DAF94C'

            WapSSLCertPath   = 'C:\Certs\WapSSL.pfx'

            FedServiceName   = 'sts.fabrikam.com'

            Role             = 'Wap Server'            

        }
    )
}