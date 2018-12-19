$ConfigurationData = @{
    AllNodes = @(
        @{NodeName = 'Server3'; FileText = 'Setting role for Server1'}
        @{NodeName = 'Server4'; FileText = 'Setting role for Server2'}
    )
}

Configuration AddFile
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $AllNodes.NodeName
    {
        File TestFile
        {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Contents = $Node.FileText
            Force = $true
        }
    }
}