$ConfigurationData = @{
    AllNodes = @(
        @{NodeName = 'Server5'; Role = 'Hyper-V'},
        @{NodeName = 'Server6'; Role = 'AD'}
    )
}

Configuration RoleConfiguration
{
    param ($Role)
    switch ($Role)
    {
        'Hyper-V'
        {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            WindowsFeature Hyper-V
            {
                Ensure = 'Present'
                Name = 'Hyper-V-PowerShell'

            } # end WindowsFeature Hyper-V

        } # end 'Hyper-V'

        'AD'
        {
            Import-DscResource -ModuleName PSDesiredStateConfiguration
            WindowsFeature AD
            {
                Ensure = 'Present'
                Name = 'RSAT-AD-PowerShell'

            } # end WindowsFeature AD

        } # end 'AD'

    } # end param

} # end RoleConfiguration

Configuration ToolsConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $AllNodes.NodeName
    {
        RoleConfiguration ServerRole
        {
            Role = $Node.Role
        }
    }
} # end ToolsConfig