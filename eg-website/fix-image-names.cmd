@echo off
setlocal EnableExtensions
cd /d "%~dp0images"

if not exist "*.*" (
  echo No files in images folder.
  pause
  exit /b 1
)

echo Fixing double extensions like name.png.jpg -^> name.png ...
for %%F in (*.png.jpg) do (
  echo   ren "%%~nxF" -^> "%%~nF"
  ren "%%F" "%%~nF" 2>nul
)

if exist "*.jpeg.jpg" for %%F in (*.jpeg.jpg) do ren "%%F" "%%~nF" 2>nul

echo Done. List:
dir /b
echo.
pause
