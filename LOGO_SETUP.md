# Setup Logo Lenzo untuk Monshub UI

## Langkah Upload Logo ke Roblox:

1. **Login ke Roblox Creator Hub**
   - Buka: https://create.roblox.com/
   - Login dengan akun Roblox Anda

2. **Upload Lenzo Logo**
   - Klik **Development Items** atau **Assets**
   - Pilih **Decals** atau **Images**
   - Klik **Upload Asset**
   - Pilih file: `image/lenzo logo.png`
   - Beri nama: "Lenzo Logo"
   - Klik **Upload**

3. **Copy Asset ID**
   - Setelah upload, buka asset yang baru di-upload
   - URL akan seperti: `https://www.roblox.com/library/123456789/Lenzo-Logo`
   - Copy angka `123456789` (ini adalah Asset ID)

4. **Update ExampleUI.lua**
   - Buka file `ExampleUI.lua`
   - Cari baris: `Icon = "rbxassetid://YOUR_LENZO_LOGO_ASSET_ID"`
   - Ganti `YOUR_LENZO_LOGO_ASSET_ID` dengan Asset ID yang Anda copy
   - Contoh: `Icon = "rbxassetid://123456789"`
   - Lakukan untuk kedua lokasi (Window dan OpenButton)

5. **Push ke GitHub**
   ```bash
   git add ExampleUI.lua
   git commit -m "Update lenzo logo asset ID"
   git push
   ```

## Alternatif: Menggunakan URL Langsung

Jika tidak ingin upload ke Roblox, bisa menggunakan URL hosting:
- Upload `lenzo logo.png` ke GitHub Releases atau image hosting
- Gunakan format: `game:HttpGet("URL_GAMBAR_ANDA")`

---

**Note:** Logo lenzo sudah ada di folder `image/lenzo logo.png`
