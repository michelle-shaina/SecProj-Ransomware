# === RSA Public Key für AES-Key-Verschlüsselung ===
$publicKeyXml = Get-Content -Path "C:\tmp\public_key.xml" -Raw

# === AES-Key erzeugen und speichern ===
$aesKey = New-Object byte[] 32
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($aesKey)

# AES-Key mit Public Key verschlüsseln
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsa.FromXmlString($publicKeyXml)
$encryptedKey = $rsa.Encrypt($aesKey, $true)
[IO.File]::WriteAllBytes("C:\tmp\key.enc", $encryptedKey)

# === AES-encoding mit zufälligem IV für die Datei ===
function Encrypt-FileContent {
    param([string]$path)
    try {
        # Dateiinhalt laden
        $content = Get-Content -Path $path -Raw -ErrorAction Stop
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)

        # AES-Objekt erzeugen
        $aes = New-Object System.Security.Cryptography.AesManaged
        $aes.GenerateIV()  # Zufälliges IV erzeugen
        $iv = $aes.IV
        $aes.KeySize = 256  # AES-Schlüsselgröße
        $aes.BlockSize = 128  # AES Blockgröße
        $aes.Key = $aesKey  # Verschlüsselungsschlüssel setzen
        $aes.IV = $iv  # Initialisierungsvektor setzen
        $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7

        # Verschlüsseln der Datei
        $encryptor = $aes.CreateEncryptor()
        $encrypted = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length)

        # Verschlüsselte Datei speichern (mit IV und verschlüsseltem Inhalt)
        $final = New-Object byte[] ($iv.Length + $encrypted.Length)
        [Array]::Copy($iv, 0, $final, 0, $iv.Length)
        [Array]::Copy($encrypted, 0, $final, $iv.Length, $encrypted.Length)
        [System.IO.File]::WriteAllBytes($path, $final)
        
        Write-Host "Die Datei wurde erfolgreich verschlüsselt."
    } catch {
        Write-Host "Fehler: $_"
    }
}

# === Nur die Datei "text.txt" verschlüsseln ===
$targetFile = "C:\tmp\text.txt"

# Sicherstellen, dass die Datei existiert
if (Test-Path $targetFile) {
    Encrypt-FileContent -path $targetFile
} else {
    Write-Host "Die Datei 'text.txt' existiert nicht im angegebenen Verzeichnis."
}
