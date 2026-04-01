# 将聊天里导出的 PNG 一键复制为网站所需文件名。
# 用法：在资源管理器中右键「使用 PowerShell 运行」，或在 eg-website 目录执行：
#   powershell -ExecutionPolicy Bypass -File .\copy-images.ps1
# 如默认路径不存在，请修改下面的 $SourceDirs 为你存放原始 PNG 的文件夹。

$ProjectRoot = $PSScriptRoot
$DestDir = Join-Path $ProjectRoot "images"
New-Item -ItemType Directory -Force -Path $DestDir | Out-Null

$SourceDirs = @(
  "C:\Users\12453\.cursor\projects\C-Users-12453-AppData-Local-Temp-2dd412ea-12b9-4c46-965b-40cabaf8a35e\assets",
  (Join-Path $ProjectRoot "source-photos")
)

$Rules = @(
  @{ Key = "2c31f7e5";    Out = "batumi-skyline.png" }
  @{ Key = "f8490ed0";   Out = "bus-selfie-turkey.png" }
  @{ Key = "358156ea";   Out = "turkey-road-transfer.png" }
  @{ Key = "fa0d2602";   Out = "black-sea-coast.png" }
  @{ Key = "c03c1859";   Out = "night-bus-interior.png" }
)

$Src = $null
foreach ($d in $SourceDirs) {
  if (Test-Path -LiteralPath $d) {
    $Src = $d
    break
  }
}

if (-not $Src) {
  Write-Host "未找到图片源目录。请将 5 张 PNG 放入: $DestDir`n并命名为 batumi-skyline.png, bus-selfie-turkey.png, turkey-road-transfer.png, black-sea-coast.png, night-bus-interior.png`n详见 images\如何放照片.txt" -ForegroundColor Yellow
  exit 1
}

foreach ($r in $Rules) {
  $hit = Get-ChildItem -LiteralPath $Src -Filter "*.png" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*$($r.Key)*" } |
    Select-Object -First 1
  if (-not $hit) {
    Write-Host "缺少包含 $($r.Key) 的源文件，跳过 $($r.Out)" -ForegroundColor Red
    continue
  }
  $target = Join-Path $DestDir $r.Out
  Copy-Item -LiteralPath $hit.FullName -Destination $target -Force
  Write-Host "OK $($r.Out) <= $($hit.Name)"
}

Write-Host "完成。用浏览器打开 index.html 即可预览。" -ForegroundColor Green
