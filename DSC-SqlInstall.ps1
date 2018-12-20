Configuration SqlInstall
{
    
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName
    )

    Import-DscResource -ModuleName SqlServerDsc
    Node $ComputerName
    {
        WindowsFeature 'NetFramework45'
        {
            Name = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }

        SqlSetup 'InstallDefaultInstance'
        {
            InstanceName = 'MSSQLSERVER'
            Features = 'SQLENGINE'
            SourcePath = '\\lcowd\SQL2016'
            SQLSysAdminAccounts = @('domain admins')
            DependsOn = '[WindowsFeature]NetFramework45'
        }
    }
}

SqlInstall -OutputPath D:\Tests\MOF 