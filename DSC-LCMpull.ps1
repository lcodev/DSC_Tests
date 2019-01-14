[DSCLocalConfigurationManager()]
Configuration LCMpull {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $guid,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $ThumbPrint
    )

    Node $ComputerName {
        Settings {
            AllowModuleOverwrite = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RefreshMode = 'Pull'
            ConfigurationID = $guid
        }

        # Pull server settings
        ConfigurationRepositoryWeb DSCHTTPS {
            ServerURL = 'https://Dsc:8080/PSDSCPullServer.svc'
            CertificateID = $ThumbPrint
            AllowUnsecureConnection = $false
        }

        # Report server settings
        ReportServerWeb RepSrv {
            ServerURL = 'https://Dsc:9080/PSDSCPullServer.svc'
            CertificateID = $ThumbPrint
            AllowUnsecureConnection = $false
        }
    }
}

# Generate new GUID
$guid = New-Guid | Select-Object -ExpandProperty GUID
#$guid = 'ab2db52d-0fb1-4685-9e6c-68338342c9ea'
$ThumbPrint = Invoke-Command -ComputerName Dsc {
    Get-ChildItem Cert:\LocalMachine\My |
    Where-Object Subject -Like 'CN=Dsc*' |
    Select-Object -ExpandProperty ThumbPrint 
}

$HostName = Read-Host 'enter hostname'
LCMpull -ComputerName $HostName -Guid $guid -ThumbPrint $ThumbPrint -OutputPath .\MOF