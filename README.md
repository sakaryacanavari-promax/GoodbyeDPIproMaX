# GoodbyeDPI Pro MAX

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%2F%2011%20(x64)-informational.svg)]()
[![Language](https://img.shields.io/badge/Language-C%23%20%2F%20.NET%20Framework-brightgreen.svg)]()

**GoodbyeDPI Pro MAX**, Türkiye'deki internet servis sağlayıcılarının uyguladığı Derin Paket İncelemesi (DPI) tabanlı engelleri aşmak, Discord ve çevrimiçi oyun bağlantılarını optimize etmek amacıyla geliştirilmiş modern, şeffaf ve açık kaynaklı bir Windows grafik arayüzüdür.

Proje, [ValdikSS/GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) çekirdek motoru ve [basil00/WinDivert](https://github.com/basil00/WinDivert) sürücüsü üzerinde çalışır; kullanıcının herhangi bir komut satırı parametresiyle uğraşmasına gerek kalmadan en hızlı ve kararlı profili otomatik olarak yapılandırır.

---

## 🌟 Temel Özellikler

- **Modern & Akıcı Arayüz:** Windows 11 Fluent tasarım diliyle uyumlu, GPU dostu ve hafif C# Windows Forms mimarisi.
- **Akıllı ISS & Profil Tespiti:** Superonline, Türk Telekom, Vodafone, Kablonet ve TurkNet için özel olarak optimize edilmiş parametre kombinasyonları.
- **Düşük Gecikmeli DNS Kıyaslama (Benchmark):** Cloudflare, Quad9, Google, AdGuard ve OpenDNS sunucularını canlı olarak test eder ve en hızlı/sansürsüz DNS'i seçer.
- **Discord & Oyun İyileştirici:** Discord ses/medya kopmalarını (WebRTC RTC Bağlanıyor sorunu) ve Roblox bağlantı sorunlarını tek tıkla onarır.
- **Dahili Güvenlik & Defender Uyumu:** Program ilk açılışta kendi klasörünü Windows Defender dışlamalarına otomatik olarak tanımlar; yanlış virüs uyarılarını (false positive) engeller.
- **Tamamen Açık Kaynak & Şeffaf:** Herhangi bir reklam, gizli proxy veya kullanıcı verisi toplama içermez. Ağ paketleri yalnızca yerel makinede filtrelenir.

---

## 🏗️ Mimari & Dosya Yapısı

```
GoodbyeDPIproMaX/
├── GoodbyeDPI_GUI.cs              # Ana C# kaynak kodu (Arayüz, mantık, DNS & telemetri)
├── app.manifest                   # Windows DPI-Awareness ve Yönetici hakları manifesti
├── app.ico                        # Uygulama simgesi
├── compile_promax.ps1             # Microsoft csc.exe ile yerel derleme ve imzalama betiği
├── Windows_Guvenligi_Izin_Ver.bat # Güvenlik izinleri için alternatif toplu iş betiği
├── core/
│   ├── discord_whitelist.txt      # Bypas edilecek alan adları listesi
│   └── x86_64/
│       ├── goodbyedpi.exe         # Upstream GoodbyeDPI 64-bit motoru
│       ├── WinDivert.dll          # WinDivert kullanıcı alanı kütüphanesi
│       └── WinDivert64.sys        # İmzalı WinDivert çekirdek sürücüsü
├── version.json                   # Otomatik güncelleme akış dosyası
├── LICENSE                        # MIT Açık Kaynak Lisansı
└── README.md                      # Proje dokümantasyonu
```

---

## ⚙️ Kaynaktan Derleme (Build from Source)

Uygulama, harici ağır bağımlılıklar (Visual Studio IDE zorunluluğu) olmadan, doğrudan Windows ile birlikte gelen yerel Microsoft .NET derleyicisi (`csc.exe`) ile derlenebilir:

### Gereksinimler:
- Windows 10 veya Windows 11 (64-bit)
- .NET Framework 4.8 veya üzeri (Windows ile yerleşik gelir)

### Derleme Adımları:
1. Depoyu klonlayın veya indirin:
   ```bash
   git clone https://github.com/sakaryacanavari-promax/GoodbyeDPIproMaX.git
   cd GoodbyeDPIproMaX
   ```
2. PowerShell üzerinden derleme betiğini çalıştırın:
   ```powershell
   powershell -ExecutionPolicy Bypass -File compile_promax.ps1
   ```
3. Derleme tamamlandığında `GoodbyeDPI_ProMAX.exe` başarıyla oluşturulacaktır.

---

## 🛡️ Güvenlik ve Kod İmzalama (Code Signing)

GoodbyeDPI Pro MAX, açık kaynak standartlarına tam uyumludur:
- WinDivert sürücüsü (`WinDivert64.sys`) resmi Microsoft donanım sertifikası ile imzalanmıştır.
- GitHub Actions CI/CD akışı üzerinde [SignPath.io](https://signpath.io) açık kaynak sertifikasyon altyapısı ile dijital olarak doğrulanır ve imzalanır.

---

## 📜 Lisans & Teşekkürler

Bu proje **MIT Lisansı** altında sunulmaktadır. Ayrıntılar için [LICENSE](LICENSE) dosyasına göz atabilirsiniz.

**Kullanılan Açık Kaynak Çekirdekler:**
- [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) - Telif Hakkı (c) ValdikSS (Apache License 2.0)
- [WinDivert](https://github.com/basil00/WinDivert) - Telif Hakkı (c) basil00 (LGPLv3 / GPLv2)
