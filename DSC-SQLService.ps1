Configuration SqlService {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName
    )

    # Import required resources
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $ComputerName {

        # Set sql server to always running
        Service MSSQLSERVER {
            Name = 'mssqlserver'
            State = 'running'
        }

        # Set sql server agent to always running
        Service SqlAgentService {
            Name = 'sqlserveragent'
            State = 'running'
        }
    }
}

SqlService -ComputerName sql1 -OutputPath .\MOF