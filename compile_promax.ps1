param(
    [string]$TargetExe = ""
)

$ErrorActionPreference = "Stop"

$dir = $PSScriptRoot
$csc = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
$src = Join-Path $dir "GoodbyeDPI_GUI.cs"
$out = if ($TargetExe) { $TargetExe } else { Join-Path $dir "GoodbyeDPI_ProMAX.exe" }
$ico = Join-Path $dir "app.ico"
$manifest = Join-Path $dir "app.manifest"
$tempOut = Join-Path $dir ("GoodbyeDPI_ProMAX.build." + [Guid]::NewGuid().ToString("N") + ".exe")
$backup = Join-Path $dir ("GoodbyeDPI_ProMAX.backup." + [Guid]::NewGuid().ToString("N") + ".exe")
$exitCode = 0

try {
    foreach ($requiredPath in @($csc, $src, $ico, $manifest)) {
        if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
            throw "Gerekli dosya bulunamadi: $requiredPath"
        }
    }

    if ([System.IO.Path]::GetFileName($out) -eq "GoodbyeDPI_ProMAX.exe" -and (Get-Process -Name "GoodbyeDPI_ProMAX" -ErrorAction SilentlyContinue)) {
        throw "Uygulama halen calisiyor. Surucuyu ve motoru duzgun kapatmak icin once uygulamadan cikis yapin; derleyici uygulamayi zorla sonlandirmaz."
    }

    $compilerArgs = @(
        "/nologo",
        "/warn:4",
        "/warnaserror+",
        "/target:winexe",
        "/optimize+",
        "/win32icon:$ico",
        "/win32manifest:$manifest",
        "/out:$tempOut",
        $src
    )

    Write-Host "GoodbyeDPI Pro MAX derleniyor (uyarilar hata sayilir)..."
    $compilerOutput = & $csc $compilerArgs 2>&1
    $compilerExitCode = $LASTEXITCODE
    foreach ($line in $compilerOutput) { Write-Host $line }
    if ($compilerExitCode -ne 0) {
        throw "Derleyici basarisiz oldu (cikis kodu $compilerExitCode). Mevcut EXE korunmustur."
    }
    if (-not (Test-Path -LiteralPath $tempOut -PathType Leaf) -or (Get-Item -LiteralPath $tempOut).Length -le 0) {
        throw "Derleyici basarili kod dondurdu ancak gecerli gecici EXE olusmadi. Mevcut EXE korunmustur."
    }

    # Authenticode Dijital Imzalama (Sezgisel antivirus ve SmartScreen uyarilarini azaltmak icin)
    try {
        $cert = Get-Item 'Cert:\CurrentUser\My\CB4191136051DDA02CDFC90D8D4CAE152D4B0DFF' -ErrorAction SilentlyContinue
        if ($cert) {
            Write-Host "Authenticode dijital imzasi uygulaniyor..."
            $sig = Set-AuthenticodeSignature -FilePath $tempOut -Certificate $cert -TimestampServer 'http://timestamp.digicert.com' -ErrorAction SilentlyContinue
            if (-not $sig -or ($sig.Status -ne "UnknownError" -and $sig.Status -ne "Valid")) {
                Set-AuthenticodeSignature -FilePath $tempOut -Certificate $cert -ErrorAction SilentlyContinue | Out-Null
            }
        }
    } catch {}

    # Derleme boyunca uygulama açılmış olabilir; çalışan motoru kesmeden güvenli şekilde iptal et.
    if ([System.IO.Path]::GetFileName($out) -eq "GoodbyeDPI_ProMAX.exe" -and (Get-Process -Name "GoodbyeDPI_ProMAX" -ErrorAction SilentlyContinue)) {
        throw "Derleme sirasinda uygulama yeniden acildi. Mevcut EXE korundu; uygulamayi kapatip tekrar derleyin."
    }

    if (Test-Path -LiteralPath $out -PathType Leaf) {
        [System.IO.File]::Replace($tempOut, $out, $backup)
        Remove-Item -LiteralPath $backup -Force -ErrorAction SilentlyContinue
    } else {
        [System.IO.File]::Move($tempOut, $out)
    }

    Write-Host "BUILD SUCCESS: compiler exit code 0; /warn:4 and warnings-as-errors enabled."
}
catch {
    Write-Host "BUILD FAILED: $($_.Exception.Message)"
    $exitCode = 1
}
finally {
    Remove-Item -LiteralPath $tempOut -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $backup -Force -ErrorAction SilentlyContinue
}

exit $exitCode
