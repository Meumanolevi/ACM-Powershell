@echo off
setlocal EnableExtensions

REM Detecta PowerShell sem mostrar mensagens
set "PS_CMD="
where powershell.exe >nul 2>&1 && set "PS_CMD=powershell.exe"
if not defined PS_CMD (
    where pwsh.exe >nul 2>&1 && set "PS_CMD=pwsh.exe"
)

REM Se nenhum PowerShell for encontrado, sai em silêncio
if not defined PS_CMD exit /b 1

REM Caminho do script
set "SCRIPT=%~dp0menu.ps1"

REM Se script não existir, sai em silêncio
if not exist "%SCRIPT%" exit /b 1

REM Mensagem discreta de execução
echo Abrindo o Menu...

REM Executa o script em terminal limpo, mantendo a janela aberta após
%PS_CMD% -NoLogo -NoProfile -ExecutionPolicy Bypass -NoExit -File "%SCRIPT%"

endlocal
exit /b
