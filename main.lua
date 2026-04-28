-- Main loader: load EXE5 UI trước, sau đó BananaHub
local BASE = "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/"

-- Bước 1: Build toàn bộ EXE5 UI
loadstring(game:HttpGet(BASE .. "exe5_loader.lua"))()
task.wait(0.8)

-- Bước 2: Load BananaHub (đã dùng exe5_adapter_lib)
loadstring(game:HttpGet(BASE .. "BananaHub_EXE5.lua"))()
