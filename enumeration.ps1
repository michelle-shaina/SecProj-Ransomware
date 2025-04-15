$log = @()

# Registry: Gemappte Laufwerke (HKCU:\Network)
try {
    $mapped = Get-ItemProperty -Path "HKCU:\Network" -ErrorAction SilentlyContinue
    $mapped.PSChildName | ForEach-Object {
        $log += "REGISTRY: \\$($_)"
    }
} catch {}

#DNS-Auflösung (z. B. bekannte Servernamen)
$dnsTargets = "fileserver", "nas01", "srv-data", "printserver", "backupsrv"
foreach ($name in $dnsTargets) {
    try {
        $fqdn = "$name.$env:USERDNSDOMAIN"
        $resolved = Resolve-DnsName $fqdn -ErrorAction SilentlyContinue
        if ($resolved) {
            $log += "DNS: $fqdn → $($resolved.IPAddress)"
        }
    } catch {}
}

# SYSVOL GPO & Logon-Skript-Analyse
try {
    $sysvol = "\\$env:USERDNSDOMAIN\SYSVOL"
    $paths = Get-ChildItem -Path $sysvol -Recurse -Include *.bat,*.ps1 -ErrorAction SilentlyContinue
    foreach ($file in $paths) {
        $matches = Select-String -Path $file.FullName -Pattern '\\\\[a-zA-Z0-9\.\-]+\\[a-zA-Z0-9\$\\-]+' -AllMatches
        foreach ($m in $matches.Matches) {
            $log += "SYSVOL: $($m.Value)"
        }
    }
} catch {}

# .lnk-Dateien aus „Zuletzt verwendet“
try {
    $recent = "$env:APPDATA\Microsoft\Windows\Recent"
    Get-ChildItem -Path $recent -Filter *.lnk -ErrorAction SilentlyContinue |
        ForEach-Object {
            $target = ($_ | Select-String '\\\\[a-zA-Z0-9\.\-]+\\[a-zA-Z0-9\$\\-]+').Matches.Value
            if ($target) { $log += "RECENT: $target" }
        }
} catch {}

# SMB-Client Verbindungen aber nur lokale
try {
    $events = Get-WinEvent -LogName "Microsoft-Windows-SmbClient/Connectivity" -ErrorAction SilentlyContinue
    foreach ($e in $events) {
        if ($e.Message -match '\\\\[a-zA-Z0-9\.\-]+\\[a-zA-Z0-9\$\\-]+') {
            $log += "EVENTLOG: $($Matches[0])"
        }
    }
} catch {}

# Exportieren
$log = $log | Sort-Object -Unique
$logFile = "C:\tmp\stealth_recon_log.csv"
$log | Set-Content -Path $logFile -Encoding UTF8
Write-Host "Ergebnis gespeichert unter: $logFile"
