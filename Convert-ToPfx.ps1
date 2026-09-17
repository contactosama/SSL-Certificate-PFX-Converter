# Define the file paths for certificate and private key
$certificatePath = "C:\Users\MAK\Desktop\saudi-new-ssl\cert.crt"
$privateKeyPath = "C:\Users\MAK\Desktop\saudi-new-ssl\key.pem"

# Define output PFX file path
$outputPfxPath = "C:\Users\MAK\Desktop\saudi-new-ssl\abcsslxyzzz.pfx"

# Check if OpenSSL is installed and its path is correct (use full path for now)
$opensslPath = "C:\Program Files\OpenSSL-Win64\bin\openssl.exe"

# Verify if OpenSSL is accessible
if (-Not (Test-Path $opensslPath)) {
    Write-Output "OpenSSL is not installed or the path is incorrect. Please install OpenSSL or correct the path."
    Pause
    exit
}

# Get the modulus of the certificate and private key
$certModulus = & $opensslPath x509 -noout -modulus -in $certificatePath | & $opensslPath md5
$keyModulus = & $opensslPath rsa -noout -modulus -in $privateKeyPath | & $opensslPath md5

# Compare the two hashes to see if the certificate and private key match
if ($certModulus -eq $keyModulus) {
    Write-Output "The SSL certificate and private key match."
} else {
    Write-Output "The SSL certificate and private key do NOT match."
    Pause
    exit
}

# Convert the certificate and private key to PFX
Write-Output "Converting certificate and private key to PFX format..."
& $opensslPath pkcs12 -export -out $outputPfxPath -inkey $privateKeyPath -in $certificatePath

Write-Output "PFX file created successfully at: $outputPfxPath"

# Pause to keep PowerShell window open
Pause
