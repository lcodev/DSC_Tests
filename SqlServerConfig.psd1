@{
    AllNodes = @(
        @{
            # This applies to all the nodes
            NodeName = '*'
            PSDscAllowPlainTextPassword = $true
            Net45 = 'NET-Framework-45-Core'
            Ensure = 'Present'
            InstanceName = 'MSSQLSERVER'
            Features = 'SQLENGINE'
            SourcePath = '\\lcowd\Software\sqlserver\SQL2016'
            SecurityMode = 'SQL'
            SQLSysAdminAccounts = @('domain admins')
            DependsOn = '[WindowsFeature]NetFramework45'
            SqlFirewallName = 'SQL'
            DisplayName = 'SQL Server'
            Direction = 'Inbound'
            Protocol = 'TCP'
            LocalPort = '1433'
            Action = 'Allow'
            Description = 'Default firewall rule for SQL server engine'
            MssqlServer = 'mssqlserver'
            SqlServerAgent = 'sqlserveragent'
            State = 'running'
        }

        @{
            NodeName = 'lco-sql2'
        }

        @{
            NodeName = 'lco-sql3'
        }
    )
}