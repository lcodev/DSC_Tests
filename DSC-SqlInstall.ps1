Configuration SqlInstall
{
    
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
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
            SourcePath = 'D:\'
            SQLSysAdminAccounts = @('domain admins')
            DependsOn = '[WindowsFeature]NetFramework45'
        }
    }
}

SqlInstall -OutputPath E:\MOF 