# SecProj-Ransomware
Meine erarbeiteten Scripts zu meinem Projekt im Secure Project. 
Allgemein habe ich mich in einem Windows 11 Umfeld bewegt. Ich versuche hier alle Skripts so zu erklären, dass diese auch selbst getestet werden können. 
Die KQL-Query, wurde auf der internen Umgebung im Geschäft getestet auf dem Microsoft Defender Endpoint über Advanced Hunting. Diese kann selbst im Unternehmen getestet werden oder mit einer guten Test-Umgebung die selbst aufgebaut wurde mit den richtigen Testdaten. Dieses Skript werde ich in dem Fall auch nur so erklären, dass es in einer fertig aufgesetzten Umgebung getestet werden könnte.

## AES-Verschlüsselungs-Skript
Vorsaussetzung: C:\ Verzeichnis und ein Ordner der tmp heisst, also: C:\tmp. 
