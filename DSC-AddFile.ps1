Configuration AddFile
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node Server1
    {
        File TestFile
        {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Force = $true
        }
    }
}