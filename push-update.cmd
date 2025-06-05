@echo off
cd /d D:\Documents\github\PowerShell-Renamer

echo ==============================
echo 🔍 On regarde si t'as bossé...
echo ==============================
git status

echo.

REM Vérification s'il y a quelque chose à faire
FOR /F "tokens=*" %%i IN ('git status --porcelain') DO (
    echo ==============================
    echo 🧠 Bon, y'a du neuf ! On commit !
    echo ==============================
    git add .
    git commit -m "🚀 Auto-push : Mise à jour magique du script ou README 🤖✨"
    git push origin main
    goto :EOF
)

echo ==============================
echo 💤 RAS mon pote, t'as rien changé !
echo ==============================
pause
