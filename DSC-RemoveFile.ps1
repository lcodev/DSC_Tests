Configuration RemoveFile
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node Server2
    {
        File TestFile
        {
            Ensure = 'Absent'
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Force = $true
        }

        File TestFolder
        {
            Ensure = 'Absent'
            Type = 'Directory'
            DestinationPath = 'C:\TestFolder'
            Force = $true
            DependsOn = '[File]TestFile'
        }
    }
}