@echo off
REM Скрипт для запуска через Git Bash из Windows

echo === WeatherWise - Запуск через Git Bash ===
echo.

REM Поиск Git Bash
set "GIT_BASH="
if exist "C:\Program Files\Git\bin\bash.exe" (
    set "GIT_BASH=C:\Program Files\Git\bin\bash.exe"
) else if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    set "GIT_BASH=C:\Program Files (x86)\Git\bin\bash.exe"
) else (
    echo ОШИБКА: Git Bash не найден!
    echo Установите Git for Windows: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo Найден Git Bash: %GIT_BASH%
echo.

REM Запуск скрипта через Git Bash
"%GIT_BASH%" run_app.sh

pause


