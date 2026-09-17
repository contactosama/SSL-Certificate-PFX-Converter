# SSL-Certificate-PFX-Converter

A PowerShell script that verifies whether an SSL certificate (.crt) and its private key (.pem) match, then converts them into a single .pfx (PKCS#12) file — useful for IIS, Windows servers, and Azure App Services.

📋 Prerequisites
Windows with PowerShell 5.1 or later
OpenSSL for Windows installed (default path used: C:\Program Files\OpenSSL-Win64\bin\openssl.exe)
Download: https://slproweb.com/products/Win32OpenSSL.html
Certificate file: cert.crt
Private key file: key.pem

📁 Expected File Structure
text
C:\Users\MAK\Desktop\saudi-new-ssl\
│
├── cert.crt              # Your SSL certificate
├── key.pem               # Your private key
└── abcsslxyzzz.pfx       # Generated output (after running script)
⚠️ Update the paths in the script if your folder or OpenSSL location differs.

🚀 Usage
Save the script below as Convert-ToPfx.ps1
Open PowerShell as Administrator
(If needed) Allow script execution for this session:
powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Run the script:
powershell
.\Convert-ToPfx.ps1
Enter a PFX export password when prompted by OpenSSL.

🔍 What the Script Does
1	Validates that OpenSSL and input files exist
2	Extracts the modulus from both cert and key
3	Hashes each modulus with MD5 and compares them
4	If they match → exports a .pfx file using openssl pkcs12
5	Prompts you to set a PFX export password

🔐 Why Verify the Modulus?
A certificate and private key must share the same modulus to work together. If they don't match, the resulting PFX will fail to load on IIS/Azure with errors like:
"The certificate and private key do not match"
"Cannot find the certificate and private key for decryption"
This script catches that problem before you deploy.

🧪 Manual Verification (Optional)
Run these two commands manually to compare:
openssl x509 -noout -modulus -in cert.crt | openssl md5
openssl rsa  -noout -modulus -in key.pem  | openssl md5
Both MD5 hashes must be identical.

🛠 Troubleshooting
OpenSSL is not installed...	Install OpenSSL or update $opensslPath
certificate and private key do NOT match	You have the wrong key for this cert — obtain the correct pair
PFX not created	Check for OpenSSL errors — often a wrong PFX password or bad key format
key.pem is encrypted	Remove passphrase first: openssl rsa -in key.pem -out key-decrypted.pem
.crt contains full chain	Use -certfile chain.crt with pkcs12 for a full-chain PFX

📄 License
MIT — free to use, modify, and distribute.
