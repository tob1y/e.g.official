@echo off
cd /d "%~dp0"

echo E.G. local server root: %cd%
echo Open: http://127.0.0.1:8080/
echo Press Ctrl+C to stop.
echo.

if exist "images\*.png.jpg" (
  echo [TIP] Found double extension .png.jpg in images\. Run fix-image-names.cmd once, then refresh browser.
  echo.
)

start "" "http://127.0.0.1:8080/"

where py >nul 2>&1 && py -3 -m http.server 8080 && goto :eof
where python >nul 2>&1 && python -m http.server 8080 && goto :eof

echo Python not found. Install Python or use Live Server on this folder.
pause
exit /b 1
