$ftpHost   = "ftp.avialish.com"
$ftpUser   = "avia2@avialish.com"
$ftpPass   = "Avia2301."
$localDir  = "build\web"
$remoteDir = ""

# SSL sertifika dogrulamasini atla
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

function Upload-File($localPath, $remotePath, $useSSL) {
    $bytes = [System.IO.File]::ReadAllBytes($localPath)
    $req = [System.Net.FtpWebRequest][System.Net.WebRequest]::Create($remotePath)
    $req.Method      = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $req.Credentials = [System.Net.NetworkCredential]::new($ftpUser, $ftpPass)
    $req.EnableSsl   = $useSSL
    $req.UseBinary   = $true
    $req.UsePassive  = $true
    $req.KeepAlive   = $false
    $req.Timeout          = 300000
    $req.ReadWriteTimeout = 300000
    $req.ContentLength = $bytes.Length
    $s = $req.GetRequestStream()
    $s.Write($bytes, 0, $bytes.Length)
    $s.Close()
    $req.GetResponse().Close()
}

function Make-Dir($dirUrl, $useSSL) {
    try {
        $mkd = [System.Net.FtpWebRequest][System.Net.WebRequest]::Create($dirUrl)
        $mkd.Method      = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $mkd.Credentials = [System.Net.NetworkCredential]::new($ftpUser, $ftpPass)
        $mkd.EnableSsl   = $useSSL
        $mkd.UsePassive  = $true
        $mkd.KeepAlive   = $false
        $mkd.GetResponse().Close()
    } catch {}
}

# Tum ust dizinleri recursive olusturur
function Make-Dirs-Recursive($fullPath, $useSSL) {
    $parts = $fullPath.TrimStart('/').Split('/')
    $current = ""
    foreach ($part in $parts) {
        if ($part -eq "") { continue }
        $current += "/$part"
        Make-Dir "ftp://$ftpHost$current" $useSSL
    }
}

# Once SSL=false, basarisiz olursa SSL=true dene
$trySSL = $false

# Baglanti testi
Write-Host "Baglanti test ediliyor..."
try {
    $test = [System.Net.FtpWebRequest][System.Net.WebRequest]::Create("ftp://$ftpHost/")
    $test.Method      = [System.Net.WebRequestMethods+Ftp]::ListDirectory
    $test.Credentials = [System.Net.NetworkCredential]::new($ftpUser, $ftpPass)
    $test.EnableSsl   = $false
    $test.UsePassive  = $true
    $test.Timeout     = 10000
    $test.GetResponse().Close()
    Write-Host "Baglandi (SSL=false)"
    $trySSL = $false
} catch {
    Write-Host "SSL=false basarisiz, SSL=true deneniyor..."
    try {
        $test2 = [System.Net.FtpWebRequest][System.Net.WebRequest]::Create("ftp://$ftpHost/")
        $test2.Method      = [System.Net.WebRequestMethods+Ftp]::ListDirectory
        $test2.Credentials = [System.Net.NetworkCredential]::new($ftpUser, $ftpPass)
        $test2.EnableSsl   = $true
        $test2.UsePassive  = $true
        $test2.Timeout     = 10000
        $test2.GetResponse().Close()
        Write-Host "Baglandi (SSL=true)"
        $trySSL = $true
    } catch {
        Write-Error "FTP baglantisi kurulamiyor: $_"
        exit 1
    }
}

$files = Get-ChildItem -Path $localDir -Recurse -File
$total = $files.Count
$done  = 0
$failed = @()

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring((Resolve-Path $localDir).Path.Length).Replace("\", "/")
    $remotePath   = "ftp://$ftpHost$remoteDir$relativePath"

    $dirPart = ($relativePath | Split-Path -Parent).Replace("\", "/")
    if ($dirPart -ne "") {
        Make-Dirs-Recursive "$remoteDir$dirPart" $trySSL
    }

    $ok = $false
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        try {
            Upload-File $file.FullName $remotePath $trySSL
            $done++
            Write-Host "[$done/$total] $relativePath"
            $ok = $true
            break
        } catch {
            if ($attempt -lt 3) {
                Start-Sleep -Milliseconds 500
            }
        }
    }
    if (-not $ok) {
        $failed += $relativePath
        Write-Warning "FAILED: $relativePath"
    }
}

Write-Host ""
Write-Host "Done: $done / $total files uploaded."
if ($failed.Count -gt 0) {
    Write-Host "Basarisiz ($($failed.Count) dosya):"
    $failed | ForEach-Object { Write-Host "  - $_" }
}
