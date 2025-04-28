# SecProj-Ransomware
Meine erarbeiteten Scripts zu meinem Projekt im Secure Project. 
Allgemein habe ich mich in einem Windows 11 Umfeld bewegt. Ich versuche hier alle Skripts so zu erklären, dass diese auch selbst getestet werden können. 
Die KQL-Query, wurde auf der internen Umgebung im Geschäft getestet auf dem Microsoft Defender Endpoint über Advanced Hunting. Diese kann selbst im Unternehmen getestet werden oder mit einer guten Test-Umgebung die selbst aufgebaut wurde mit den richtigen Testdaten. Dieses Skript werde ich in dem Fall auch nur so erklären, dass es in einer fertig aufgesetzten Umgebung getestet werden könnte.

## Voraussetzungen
Umfeld: Windows 11 (Version selbst sollte keine Rolle spielen)
Ordner: Auch wenn ich die einzlenen Files aus Schönheitsgründen in einzelne Ordner gepackt habe, müssen alle Files im \tmp Ordner liegen, da ich die Pfade gehardcoded habe. 

## AES-Verschlüsselungs-Skript
Vorsaussetzung: 
- :\ Verzeichnis und ein Ordner der tmp heisst, also: C:\tmp. 
- Das text.txt File
- Das File encrypt.ps1
- Das File decrypt.ps1
- Datei private_key.xml
- Datei public_key.xml
- Alles muss sich im Ordner C:\tmp befinden.

### Verschlüsseln
Jetzt eine Powershell Konsole starten und das encrypt.ps1 File ausführen.
Wenn das text.txt File jetzt geöffnet wird sollte es Verschlüsselt sein.

### Entschlüsseln
Das text.txt File wieder schliessen. In einer Powershell Konsole decrypt.ps1 ausführen
Das text.txt File sollte jetzt wieder entschlüsselt sein. 

