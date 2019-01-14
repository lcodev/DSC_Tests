[DSCLocalConfigurationManager()]
Configuration LCM {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $ComputerName
    )

    Node $ComputerName {
        Settings {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RebootNodeIfNeeded = $true
        }
    }
}

LCM -ComputerName Sql3 -OutputPath .\MOF