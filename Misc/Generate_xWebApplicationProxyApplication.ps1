#xWebApplicationProxyApplication

$Name = New-xDscResourceProperty -Name Name -Type String -Attribute Key -Description "Specifies a friendly name for the published web application."
$ADFSRelyingPartyName = New-xDscResourceProperty -Name ADFSRelyingPartyName -Type String -Attribute Write -Description "Specifies the name of the relying party configured on the AD FS federation server." 
$BackendServerAuthenticationSPN = New-xDscResourceProperty -Name BackendServerAuthenticationSPN -Type String -Attribute Write -Description "Specifies the service principal name (SPN) of the backend server. Use this parameter if the application that the backend server hosts uses Integrated Windows authentication."
$BackendServerCertificateValidation = New-xDscResourceProperty -Name BackendServerCertificateValidation -Type String -Attribute Write -ValidateSet "None","ValidateCertificate" -Description "Specifies whether Web Application Proxy validates the certificate that the backend server presents with the WAP configuration per application."
$BackendServerUrl = New-xDscResourceProperty -Name BackendServerUrl -Type String -Attribute Write -Description "Specifies the backend address of the web application. Specify by protocol and host name or IP address. Include the trailing slash (/). You can also include a port number and path."
$ClientCertificateAuthenticationBindingMode = New-xDscResourceProperty -Name ClientCertificateAuthenticationBindingMode -Type String -Attribute Write -ValidateSet "None","ValidateCertificate" -Description "If this parameter is set to ValidateCertificate then the browser sends a certificate with each request and validates that the device certificate thumbprint from the certificate is included in the token or the cookie."
$ClientCertificatePreauthenticationThumbprint = New-xDscResourceProperty -Name ClientCertificatePreauthenticationThumbprint -Type String -Attribute Write -Description "Specifies the certificate thumbprint, as a string, of the certificate that a client supplies for the preauthentication feature. This parameter is only relevant when you specify the value of ClientCertificate for the ExternalPreauthentication parameter." 
$DisableTranslateUrlInRequestHeaders = New-xDscResourceProperty -Name DisableTranslateUrlInRequestHeaders -Type Boolean -Attribute Write -Description "Indicates that Web Application Proxy does not translate HTTP host headers from public host headers to internal host headers when it forwards the request to the published application."
$DisableHttpOnlyCookieProtection = New-xDscResourceProperty -Name DisableHttpOnlyCookieProtection -Type Boolean -Attribute Write -Description "Indicates whether to disable the use of the HttpOnly flag when Web Application Proxy sets the access cookie. The access cookie provides single sign-on access to an application."
$DisableTranslateUrlInResponseHeaders = New-xDscResourceProperty -Name DisableTranslateUrlInResponseHeaders -Type Boolean -Attribute Write -Description "Indicates that Web Application Proxy does not translate internal host names to public host names in Content-Location, Location, and Set-Cookie response headers in redirect responses."
$ExternalCertificateThumbprint = New-xDscResourceProperty -Name ExternalCertificateThumbprint -Type String -Attribute Write -Description "Specifies the certificate thumbprint, as a string, of the certificate to use for the address specified by the ExternalUrl parameter."
$ExternalPreauthentication = New-xDscResourceProperty -Name ExternalPreauthentication -Type String -Attribute Write -ValidateSet "ADFS","ClientCertificate","PassThrough" -Description "Specifies the pre-authentication method that Web Application Proxy uses."
$ExternalUrl = New-xDscResourceProperty -Name ExternalUrl -Type String -Attribute Write -Description "Specifies the external address, as a URL, for the web application. Include the trailing slash (/)."
$InactiveTransactionsTimeoutSec = New-xDscResourceProperty -Name InactiveTransactionsTimeoutSec -Type Uint32 -Attribute Write -Description "Specifies the length of time, in seconds, until Web Application Proxy closes incomplete HTTP transactions."
$UseOAuthAuthentication = New-xDscResourceProperty -Name UseOAuthAuthentication -Type Boolean -Attribute Write -Description "Indicates that Web Application Proxy provides the URL of the federation server that performs Open Authorization (OAuth) when users connect to the application by using a Windows Store app."
$Ensure = New-xDscResourceProperty -Name Ensure -Type String -ValidateSet "Present","Absent" -Attribute Required -Description "Specifies if the WebApplicationProxyApplication should be present or absent"

$WebApplicationProxyAppParams = @{
    Name = 'MSFT_xWebApplicationProxyApplication'
    Property = $Name,$ADFSRelyingPartyName,$BackendServerAuthenticationSPN,$BackendServerCertificateValidation,$BackendServerUrl,$ClientCertificateAuthenticationBindingMode,$ClientCertificatePreauthenticationThumbprint,$DisableTranslateUrlInRequestHeaders,$DisableHttpOnlyCookieProtection,$DisableTranslateUrlInResponseHeaders,$ExternalCertificateThumbprint,$ExternalPreauthentication,$ExternalUrl,$InactiveTransactionsTimeoutSec,$UseOAuthAuthentication,$Ensure
    FriendlyName = 'xWebApplicationProxyApplication'
    ModuleName = 'xWebApplicationProxy'
    Path = 'C:\Program Files\WindowsPowerShell\Modules\'
}


New-xDscResource @WebApplicationProxyAppParams