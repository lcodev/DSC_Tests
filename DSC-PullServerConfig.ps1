$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'Dsc'
            Role = @('Web', 'PullServer')
            CertThumbprint = Invoke-Command -ComputerName 'Dsc' -ScriptBlock {
            Get-ChildItem -Path Cert:\LocalMachine\My |
            Where-Object Subject -Like 'CN=Dsc*' |
            Select-Object -ExpandProperty Thumbprint}
        }
    );
}

Configuration PullServer {

    # Required resource modules
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration
    
    # Install IIS
    Node $AllNodes.Where{$_.Role -eq 'Web'}.NodeName {
        WindowsFeature IIS {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        # Install IIS sub-features
        WindowsFeature NetExtens4 {
            Ensure = 'Present'
            Name = 'Web-Net-Ext45'
            DependsOn = '[WindowsFeature]IIS'
        }

        WindowsFeature AspNet45 {
            Ensure = 'Present'
            Name = 'Web-Asp-Net45'
            DependsOn = '[WindowsFeature]IIS'
        }

        WindowsFeature ISAPIExt {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Ext'
            DependsOn = '[WindowsFeature]IIS'
        }

        WindowsFeature ISAPIFilter {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Filter'
            DependsOn = '[WindowsFeature]IIS'
        }

        # IIS sub-features to block
        WindowsFeature DirectoryBrowsing {
            Ensure = 'Absent'
            Name = 'Web-Dir-Browsing'
            DependsOn = '[WindowsFeature]IIS'
        }

        WindowsFeature StaticCompression {
            Ensure = 'Absent'
            Name = 'Web-Stat-Compression'
            DependsOn = '[WindowsFeature]IIS'
        }

        # Install IIS management features
        WindowsFeature Management {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Service'
            DependsOn = @('[WindowsFeature]IIS')
        }

        # Registry configuration
        Registry RemoteManagement {
            Key = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
            ValueName = 'EnableRemoteManagement'
            ValueType = 'Dword'
            ValueData = '1'
            DependsOn = @('[WindowsFeature]IIS', '[WindowsFeature]Management')
        }

        Service StartWMSVC {
            Name = 'WMSVC'
            StartupType = 'Automatic'
            State = 'Running'
            DependsOn = '[Registry]RemoteManagement'
        }

        xWebsite DefaultSite {
            Name = 'Default Web Site'
            State = 'Started'
            PhysicalPath = 'C:\inetpub\wwwroot'
            DependsOn = '[WindowsFeature]IIS'
        }
    }

    # Install Desired State Configuration (DSC)
    Node $AllNodes.Where{$_.Role -eq 'PullServer'}.NodeName {
        WindowsFeature DSCServiceFeature {
            Ensure = 'Present'
            Name = 'DSC-Service'
        }

        xDscWebService DSCPullServer {
            Ensure = 'Present'
            EndpointName = 'PullServer'
            Port = 8080
            PhysicalPath = "$env:SystemDrive\inetpub\wwwroot\PullServer"
            CertificateThumbPrint = $Node.CertThumbprint
            ModulePath = "$env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            State = 'Started'
            UseSecurityBestPractices = $false
            DependsOn = '[WindowsFeature]DSCServiceFeature'
        }

        xDSCWebService DSCComplianceServer {
            Ensure = 'Present'
            EndpointName = 'ComplianceServer'
            Port = 9080
            PhysicalPath = "$env:SystemDrive\inetpub\wwwroot\ComplianceServer"
            CertificateThumbPrint = $Node.CertThumbprint
            State = 'Started'
            UseSecurityBestPractices = $false
            DependsOn = ('[WindowsFeature]DSCServiceFeature', '[xDSCWebService]DSCPullServer')
        }
    }
}

PullServer -ConfigurationData $ConfigurationData -OutputPath .\MOF 

                