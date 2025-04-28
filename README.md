# SecProj-Ransomware
Hier sind alle meine erarbeiteten Skripts zum Secure Project. 
Ich versuche hier alle Skripts so zu erklären, dass diese auch selbst getestet werden können. 
Die KQL-Query, wurde auf der internen Umgebung im Unternehmen getestet auf dem Microsoft Defender for Endpoint über Advanced Hunting. Diese kann selbst im Unternehmen getestet werden oder mit einer guten Test-Umgebung die selbst aufgebaut wurde. Dieses Skript werde ich in dem Fall auch nur so erklären, dass es in einer fertig aufgesetzten Umgebung getestet werden könnte.

## Voraussetzungen
- Umfeld: Windows 11 (Version selbst sollte keine Rolle spielen)
- Ordner: Auch wenn ich die einzlenen Files aus Schönheitsgründen in einzelne Ordner gepackt habe, müssen alle Files im \tmp Ordner liegen, da ich die Pfade gehardcoded habe. 
- text.txt: Das File ist wenn nichts anderes angegeben, immer im nicht verschlüsseltem Zustand zu benutzen.

## AES-Verschlüsselungs-Skript
Vorsaussetzung: 
- C:\ Verzeichnis und ein Ordner der tmp heisst, also: C:\tmp. 
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

## WMI-Szenario
Voraussetzung:
- Das Skript wmi-attack.ps1
- Das encoded.txt File
- Das text.txt File
- Alles muss sich im Ordner C:\tmp befinden.

Das encoded.txt File ist nichts anderes als das encrypt.ps1 File, einfach base64 kodiert. Im \tmp Verzeichnis eine Powershell öffnen und das Skript wmi-attack.ps1 ausführen. Danach sich als Benutzer*in abmelden und neu einloggen beim Windows. Jetzt kurz ein paar Sekunden warten bis alles gestartet ist und das File text.txt sollte jetzt AES-Verschlüsselt sein.

## DLL-Szenario
Voraussetzung: 
- Das faultrep.cs file
- werfault.exe vom eigenen System
- Eine IDE und zusätzliche Pakete zum eine DLL erstellen (oder Personal Preference Tool)
- Das text.txt File

Dieses Szenario kann wegen verschieden OS-Architekturen und Systemkonfigurationen wahrscheinlich nicht einfach mit "runterladen" getestet werden. 
Hier ist was gemacht werden kann:
1. Das faultrep.cs File aus dem DLL-Sideloading Ordner nehmen und in eine DLL konvertieren. Ich habe es mit dem DLLExport NuGet-Packet gemacht, es gibt natürlich noch andere Möglichkeiten. Das ist Personal Preference und der Anwenderperson überlassen. 
2. Als nächstes soll werfault.exe in den \tmp Ordner geladen werden, hierzu kann folgender Befehl genommen werden (je nach dem wo es sich befindet, kann das natürlich variieren): copy C:\Windows\System32\werfault.exe C:\tmp\
3. werfault.exe in crash.exe unbenennen
Jetzt sollte sich die faultrep.dll und die crash.exe im \tmp Ordner befinden. Wenn das der Fall ist, kann der Angriff mit folgendem Befehl ausgeführt werden:
Start-Process "C:\tmp\crash.exe"
Danach sollte die Datei text.txt erfolgreich verschlüsselt sein.

## Shannon-Entropie
Voraussetzung:
- Das text.txt File
- encrypt.ps1
- shannonentropie.py
- alles befindet sich im Ordner C:\tmp
- Python-Umgebung installiert, dass es in Powershell verwendet werden kann (es kann natürlich auch eine IDE verwendet werden, wieder Personal Preference)

1. Um die Entropie am Anfang zu testen ein Powershell im tmp Ordner öffnen und folgenden Befehl ausführen: python .\shannonentropie.py
2. Die Aussgabe sollte sein: Die Datei schein nicht vershclüsselt mit dem jeweiligen Wert.
3. Das File mit den encrypt.ps1 verschlüsseln (Schritt weiter oben schon beschrieben)
4. nochmals python .\shannonentropie.py
5. Jetzt solle der Hinweis kommen: Die Datei ist warhscheinlich verschlüsselt oder komprimiert.

## KQL
Voraussetzung:
- MDE
- Eine Umgebung mit Testdaten oder Produktivdaten.
- Um dies zu testen, kann das Skript ganz einfach übers Advanced Hunting in MDE getestet werden. Es deckt nur die letzten 3 Tage ab, das kann aber einfach angepasst werden auf die gewünschte Spanne.
