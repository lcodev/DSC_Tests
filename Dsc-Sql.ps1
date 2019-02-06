Configuration SqlServerInstall
{
    param 
    (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $SACredential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc
    Import-DscResource -ModuleName NetworkingDsc

    Node $AllNodes.Where({$true}).NodeName
    {
        WindowsFeature 'NetFramework45'
        {
            Ensure = $Node.Ensure
            Name = $Node.Net45
        }

        SqlSetup 'InstallDefaultInstance'
        {
            InstanceName = $Node.InstanceName
            Features = $Node.Features
            SourcePath = $Node.SourcePath
            SecurityMode = $Node.SecurityMode
            SQLSysAdminAccounts = $Node.SQLSysAdminAccounts
            DependsOn = $Node.DependsOn
            SAPwd = $SACredential
        }

        Service MSSQLSERVER
        {
            Name = $Node.MssqlServer 
            State = $Node.State
        }

        Service SqlServerAgent
        {
            Name = $Node.SqlServerAgent
            State = $Node.State
        }

        Firewall Sql_Net_Firewall_Rule
        {
            Ensure = $Node.Ensure
            Name = $Node.SqlFirewallName
            DisplayName = $Node.DisplayName
            Direction = $Node.Direction
            Protocol = $Node.Protocol
            LocalPort = $Node.LocalPort
            Action = $Node.Action
            Description = $Node.Description
        }
    }
}



SqlServerInstall -OutputPath D:\Dsc\MOF -ConfigurationData D:\Dsc\Configs\SqlServerConfig.psd1