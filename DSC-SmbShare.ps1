Configuration StdShare {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName
    )

    # Import required resources
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xSmbShare

    Node $ComputerName {

        # Create folder
        File TestFolder {
            Ensure = 'Present'
            Type = 'Directory'
            DestinationPath = 'C:\TestFolder'
            Force = $true
        }

        # Create file
        File TestFile {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Contents = 'My first configuration'
            Force = $true
        }

        # Create share
        xSmbShare StandardShare {
            Ensure = 'Present'
            Name = 'Standard'
            Path = 'C:\TestFolder'
            Description = 'This is a test SMB SHare'
            ConcurrentUserLimit = 0
        }
    }
}

StdShare -ComputerName Sql2 -OutputPath .\MOF