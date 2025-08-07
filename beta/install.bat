@echo off
setlocal EnableExtensions
:: === Verifica admin ===
net session >nul 2>&1
if %%errorlevel%% neq 0 (
^^  echo =====================================================
^^  echo   Este script precisa ser executado como ADMIN!
^^  echo   Abrindo prompt elevado...
^^  echo =====================================================
^^  powershell -NoProfile -Command "Start-Process -FilePath '%%~f0' -Verb RunAs"
^^  exit /b
)
:: === Caminhos ===
set "SCRIPT_DIR=%%~dp0"
set "SCRIPT_DIR=%%SCRIPT_DIR:~0,-1%%"
set "EXE_PATH=%%SCRIPT_DIR%%\ghclean.exe"
if not exist "%%EXE_PATH%%" (
^^  echo ERRO: Nao encontrei ghclean.exe em "%%SCRIPT_DIR%%"
^^  pause
^^  exit /b 1
)
:: Confirmacao
set /p CONFIRMA="Instalar '%%SCRIPT_DIR%%' no PATH do sistema (removendo entradas antigas do ghclean)? (S/N): "
if /i "%%CONFIRMA%%" neq "S" (
^^  echo Cancelado.
^^  pause
^^  exit /b 0
)
:: === Limpa PATH (remove 'ghclean') e adiciona pasta atual ===
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dir='%%SCRIPT_DIR%%'; $p=[Environment]::GetEnvironmentVariable('Path','Machine'); $parts=$p -split ';' ^| Where-Object { $_ -and ($_ -notmatch '(?i)\\ghclean') }; $parts += $dir; $new=($parts ^| Select-Object -Unique) -join ';'; [Environment]::SetEnvironmentVariable('Path',$new,'Machine');"
if %%errorlevel%% neq 0 (
^^  echo Falha ao atualizar PATH do sistema.
^^  pause
^^  exit /b 1
)
echo =====================================================
echo   '%%SCRIPT_DIR%%' configurado no PATH do sistema.
echo   Entradas antigas do ghclean foram removidas.
echo   Agora voce pode rodar 'ghclean' de qualquer lugar.
echo =====================================================
pause
