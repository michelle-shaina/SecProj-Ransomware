# === RSA Private Key für AES-Key-Entschlüsselung ===
$privateKeyXml = Get-Content -Path "C:\tmp\private_key.xml" -Raw  # Pfad zum privaten Schlüssel

# === AES-Schlüssel entschlüsseln ===
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsa.FromXmlString($privateKeyXml)

# Den verschlüsselten AES-Schlüssel einlesen
$encryptedKey = [IO.File]::ReadAllBytes("C:\tmp\key.enc")

# Entschlüsselung des AES-Schlüssels mit dem privaten RSA-Schlüssel
$aesKey = $rsa.Decrypt($encryptedKey, $true)

# === AES-Entschlüsselung der Datei ===
function Decrypt-FileContent {
    param([string]$path)
    try {
        # Verschlüsselte Datei als Byte-Array laden
        $encryptedContent = [IO.File]::ReadAllBytes($path)

        # Sicherstellen, dass die Datei genügend Inhalt hat
        if ($encryptedContent.Length -le 16) {
            Write-Host "Die Datei ist zu klein, um verschlüsselte Daten zu enthalten."
            return
        }

        # IV und verschlüsselten Inhalt trennen
        $ivLength = 16  # AES IV ist 16 Byte lang
        $iv = $encryptedContent[0..($ivLength - 1)]  # Erstes 16 Bytes sind der IV
        $encryptedBytes = $encryptedContent[$ivLength..($encryptedContent.Length - 1)]  # Rest sind die verschlüsselten Daten

        # Sicherstellen, dass der IV korrekt als Byte-Array behandelt wird
        $iv = [byte[]]$iv

        # AES-Objekt erzeugen
        $aes = New-Object System.Security.Cryptography.AesManaged
        $aes.KeySize = 256
        $aes.BlockSize = 128
        $aes.Key = $aesKey  # Entschlüsselter AES-Schlüssel
        $aes.IV = $iv  # Initialisierungsvektor setzen
        $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7

        # AES-Entschlüsselung
        $decryptor = $aes.CreateDecryptor()
        $decryptedBytes = $decryptor.TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length)

        # Entschlüsselte Datei zurückschreiben
        $decryptedContent = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
        [IO.File]::WriteAllText($path, $decryptedContent)  # Schreibe den entschlüsselten Inhalt zurück

        Write-Host "Die Datei wurde erfolgreich entschlüsselt."
    } catch {
        Write-Host "Fehler: $_"
    }
}

# === Nur die Datei "text.txt" entschlüsseln ===
$targetFile = "C:\tmp\text.txt"  # Die verschlüsselte Datei (text.txt)

# Sicherstellen, dass die verschlüsselte Datei existiert
if (Test-Path $targetFile) {
    Decrypt-FileContent -path $targetFile
} else {
    Write-Host "Die verschlüsselte Datei 'text.txt' existiert nicht im angegebenen Verzeichnis."
}
