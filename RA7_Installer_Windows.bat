@echo off
setlocal EnableDelayedExpansion

:: ======================================
:: RA-7 CONSCIOUS DESKTOP ASSISTANT INSTALLER (.bat)
:: ======================================
echo -----------------------------------------
echo   🔮 RA-7 Conscious Assistant - Setup
echo -----------------------------------------

:: Ensure admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo [✘] Please run as administrator.
  pause
  exit /b
)

:: Check Python
where python >nul 2>&1
if %errorlevel% neq 0 (
  echo [!] Installing Python 3.11...
  curl -o python-installer.exe https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe
  start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
  del python-installer.exe
) else (
  echo [✔] Python found.
)

:: Create Virtual Env
if not exist ra7_env (
  echo [✔] Creating virtual environment...
  python -m venv ra7_env
)

:: Activate env
call ra7_env\Scripts\activate.bat

:: Upgrade pip
python -m pip install --upgrade pip setuptools wheel

:: Install core modules
echo [✔] Installing dependencies...
pip install flask flask_cors openai pyttsx3 sounddevice soundfile SpeechRecognition llama-cpp-python numpy pillow tk schedule pygame

:: Download model folder (user must place .gguf manually)
if not exist models mkdir models

:: Copy assistant file if not present
if not exist conscious_desktop_assistant.py (
  echo [!] Please place your conscious_desktop_assistant.py in this folder before launching.
  pause
  exit /b
)

:: Launch app
echo [🚀] Starting RA-7 Assistant...
python conscious_desktop_assistant.py

:: End
echo -----------------------------------------
echo ✅ RA-7 Assistant Completed.
pause
