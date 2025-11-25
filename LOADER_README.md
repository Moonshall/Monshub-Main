# 🎮 MonsHub Universal Loader

Universal game loader untuk MonsHub yang otomatis mendeteksi game dan menjalankan script yang sesuai.

## ✨ Features

- 🔍 **Auto Game Detection** - Otomatis mendeteksi game berdasarkan PlaceID atau nama
- 📦 **Multi-Game Support** - Support multiple games dengan satu loader
- 🎨 **Modern Loading UI** - Loading screen yang cantik dengan progress bar
- 🔔 **Notifications** - Notifikasi status loading
- 🛡️ **Error Handling** - Error handling yang robust
- 🐛 **Debug Mode** - Mode debug untuk development
- ⚡ **Fast Loading** - Optimized loading speed

## 🚀 Quick Start

### Cara 1: Execute dari Web
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Moonshall/Monshub-Main/main/Mons.lua"))()
```

### Cara 2: Execute dari File
```lua
loadstring(readfile("Mons.lua"))()
```

## 📋 Configuration

Edit bagian `Config` di `Mons.lua`:

```lua
local Config = {
    Scripts = {
        ["FishIt"] = "URL_SCRIPT_FISHIT",
        ["Default"] = "URL_SCRIPT_DEFAULT"
    },
    
    Games = {
        [123456789] = "FishIt",  -- Game PlaceID
    },
    
    ShowNotifications = true,
    LoadingDelay = 0.5,
    DebugMode = false
}
```

## 🎯 Cara Menambahkan Game Baru

1. **Tambahkan Script URL:**
```lua
Scripts = {
    ["FishIt"] = "https://raw.githubusercontent.com/.../FistIt.lua",
    ["NewGame"] = "https://raw.githubusercontent.com/.../NewGame.lua",  -- Tambah ini
}
```

2. **Tambahkan Game ID:**
```lua
Games = {
    [123456789] = "FishIt",
    [987654321] = "NewGame",  -- Tambah ini
}
```

3. **Atau deteksi by name (otomatis):**
Script akan otomatis mendeteksi game berdasarkan nama jika tidak ada di database.

## 🔧 Cara Mendapatkan Game PlaceID

1. Join game yang ingin ditambahkan
2. Buka console (F9)
3. Ketik: `print(game.PlaceId)`
4. Copy PlaceID yang muncul

## 📝 Example Usage

### Fish It / Fist It Game:
```lua
-- Ketika execute di game Fish It:
loadstring(game:HttpGet("https://raw.githubusercontent.com/Moonshall/Monshub-Main/main/Mons.lua"))()

-- Loader akan otomatis:
-- 1. Deteksi bahwa ini game Fish It
-- 2. Load script FistIt.lua
-- 3. Execute script
```

## 🎨 Loading UI Preview

```
┌─────────────────────────────────┐
│          MonsHub                │
│                                 │
│  Detecting game...              │
│                                 │
│  ████████░░░░░░░░░ 60%         │
│                                 │
│              v2.0.0             │
└─────────────────────────────────┘
```

## 🐛 Debug Mode

Enable untuk troubleshooting:

```lua
local Config = {
    -- ...
    DebugMode = true  -- Set true untuk enable debug
}
```

Output di console:
```
[MonsHub] Game ID: 123456789
[MonsHub] Game Name: Fish It
[MonsHub] Detected script: FishIt
[MonsHub] Loading from URL: https://...
```

## 📂 File Structure

```
MonsHub/
├── Mons.lua              # Universal Loader (ini file)
├── FistIt.lua            # Script untuk Fish It game
├── loadstring.lua        # Default fallback script
└── README.md             # Documentation
```

## ⚙️ Advanced Configuration

### Custom Detection Logic

Edit fungsi `DetectGame()` untuk custom detection:

```lua
local function DetectGame()
    local gameId, gameName = GetGameInfo()
    
    -- Custom detection by name
    local lowerName = gameName:lower()
    
    if lowerName:find("fish") or lowerName:find("fist") then
        return "FishIt", gameName
    elseif lowerName:find("blade") then
        return "BladeGame", gameName
    elseif lowerName:find("prison") then
        return "PrisonGame", gameName
    end
    
    return "Default", gameName
end
```

### Local File Loading

Untuk development, loader akan cek file lokal dulu:

```lua
-- Auto check file lokal jika ada
readfile("FistIt.lua")  -- Akan load dari lokal
```

## 🔒 Security Features

- ✅ Protected GUI placement
- ✅ Error handling untuk semua operations
- ✅ Safe HTTP requests
- ✅ Environment validation

## ⚡ Performance

- Fast game detection (< 0.5s)
- Parallel loading support
- Optimized UI rendering
- Minimal memory footprint

## 🆘 Troubleshooting

### Script tidak load?
1. Check internet connection
2. Verify script URL masih valid
3. Enable DebugMode untuk lihat error
4. Check executor support HttpGet

### Game tidak terdeteksi?
1. Check PlaceID di console: `print(game.PlaceId)`
2. Tambahkan PlaceID ke Config.Games
3. Atau biarkan auto-detect by name

### Loading UI tidak muncul?
1. Check executor support GUI
2. Try different GUI protection method
3. Check if CoreGui accessible

## 📊 Status Codes

- ✅ **Success** - Script loaded successfully
- ❌ **Error** - Failed to load script
- ⚠️ **Warning** - Minor issues, script may work

## 🔄 Updates

**v2.0.0** (Current)
- Universal loader system
- Auto game detection
- Modern loading UI
- Multi-game support
- Error handling improvements

## 📞 Support

- Issues: [GitHub Issues](https://github.com/Moonshall/Monshub-Main/issues)
- Discord: [Join Server](https://discord.gg/your-server)

## 📜 License

© 2025 MonsHub - All Rights Reserved

---

**Made with ❤️ by Mons**
