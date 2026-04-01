@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Double-click this file (no PowerShell). Copies PNGs into images\ with fixed names.

set "DST=%~dp0images"
if not exist "%DST%" mkdir "%DST%"

set "CURSOR_ASSETS=C:\Users\12453\.cursor\projects\C-Users-12453-AppData-Local-Temp-2dd412ea-12b9-4c46-965b-40cabaf8a35e\assets"
set "LOCAL_SRC=%~dp0source-photos"

set "SRC=!CURSOR_ASSETS!"
if not exist "!SRC!\" set "SRC=!LOCAL_SRC!"

dir /b "!SRC!\*.png" 2>nul | findstr /r "." >nul
if errorlevel 1 (
  chcp 65001 >nul
  echo [错误] 下面这个文件夹里没有 PNG：
  echo   !SRC!
  echo.
  echo 请把 5 张原始 PNG 放进 eg-website\source-photos\ 后，再双击本文件；
  echo 或用记事本改本文件里的 set CURSOR_ASSETS= 路径。
  echo.
  pause
  exit /b 1
)

set /a OK=0
call :copyone "*2c31f7e5*"   "batumi-skyline.png"
call :copyone "*f8490ed0*"  "bus-selfie-turkey.png"
call :copyone "*358156ea*"  "turkey-road-transfer.png"
call :copyone "*fa0d2602*"  "black-sea-coast.png"
call :copyone "*c03c1859*"  "night-bus-interior.png"

chcp 65001 >nul
echo.
if !OK! EQU 0 (
  echo [重要] 没有任何文件复制成功。网页里的照片会显示不出来。
  echo 请把 5 张 PNG 放进 source-photos 或修正 CURSOR_ASSETS 路径后重试。
  pause
  exit /b 1
)
if !OK! LSS 5 echo [警告] 仅成功 !OK! / 5 张，请对照屏幕上方的 [失败] / [跳过] 排查。
echo 完成（成功 !OK! 张）。用浏览器打开 index.html 预览。
echo.
pause
exit /b 0

:copyone
set "OUT=%~2"
set "HIT="
for %%F in ("!SRC!\%~1.png") do set "HIT=%%~fF"
if not defined HIT (
  echo [跳过] %~1 -^> %OUT%
  exit /b 0
)
copy /Y "!HIT!" "!DST!\!OUT!" >nul
if errorlevel 1 (
  echo [失败] !OUT!
  exit /b 0
)

set /a OK+=1
echo [成功] !OUT!
exit /b 0
