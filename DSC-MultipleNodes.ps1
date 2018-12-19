Configuration AddFile
{
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $ComputerName
    {
        File TestFile
        {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Contents = 'My first configuration'
            Force = $true
        }
    }
}