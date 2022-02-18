Param(
    [Parameter(Mandatory = $true)]
    [string]$remote_server,
    [parameter(Mandatory = $true)]
    [string]$remote_user_name,
    [parameter(Mandatory = $true)]
    [SecureString]$remote_password,
    [Parameter(Mandatory = $true)]
    [string]$cert_path,
    [Parameter(Mandatory = $true)]
    [string]$cert_store,
    [Parameter(Mandatory = $false)]
    [SecureString]$cert_password,
    [Parameter(Mandatory = $true)]
    [bool]$is_pfx_cert
)

# validate
if ($is_pfx_cert -and -not $cert_password) {
    Write-Error "Password must be specified for certs containing private key" -ErrorAction Stop
}

$credential = [PSCredential]::new($remote_user_name, $remote_password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

[Byte[]]$cert_data = Get-Content -Path $cert_path -Encoding Byte
$cert_file_parts = $($cert_path).Replace('/', '\').Split('\')
$cert_file_name = $cert_file_parts[$cert_file_parts.Length - 1]
$rand = -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object { [char]$_ })
$remote_cert_directory = "c:\$rand-cert-install"
$remote_cert_path = (Join-Path -Path $remote_cert_directory -ChildPath $cert_file_name)

$script = {
    try {
        New-Item -Path $Using:remote_cert_directory -ItemType Directory -Force
        Set-Content -Path $Using:remote_cert_path -Value $Using:cert_data -Encoding Byte

        $cert_args = @{
            FilePath          = $Using:remote_cert_path
            CertStoreLocation = $Using:cert_store
        }

        if ($Using:is_pfx_cert) {
            $cert_args['Password'] = $Using:cert_password
            Import-PfxCertificate @Using:cert_args
        }
        else {
            Import-Certificate @cert_args
        }
        Remove-Item -Path $Using:remote_cert_directory -Force -Recurse

        Write-Host "Certificate Imported"
    }
    catch {
        Write-Error "Error Importing Cert"
        Write-Error $_ -ErrorAction Stop
    }
}

Invoke-Command -ComputerName $server `
    -Credential $credential `
    -UseSSL `
    -SessionOption $so `
    -ScriptBlock $script
