#!/bin/bash

echo "🔮 RA-7 Conscious Assistant - Linux Installer"
echo "--------------------------------------------"

# Check for sudo
if [ "$EUID" -ne 0 ]
  then echo "[✘] Please run as root (sudo)."
  exit
fi

# Update packages
echo "[✔] Updating packages..."
apt update && apt upgrade -y

# Install dependencies
echo "[✔] Installing core system dependencies..."
apt install -y python3 python3-pip python3-venv cmake build-essential libportaudio2 libportaudio-dev libffi-dev libopenblas-dev libssl-dev git curl

# Create venv
if [ ! -d "ra7_env" ]; then
  echo "[✔] Creating virtual environment..."
  python3 -m venv ra7_env
fi

# Activate venv
source ra7_env/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel

# Install Python modules
echo "[✔] Installing Python dependencies..."
pip install flask flask_cors openai pyttsx3 sounddevice soundfile SpeechRecognition llama-cpp-python numpy pillow tk schedule pygame

# Check for assistant script
if [ ! -f "conscious_desktop_assistant.py" ]; then
  echo "[✘] Place 'conscious_desktop_assistant.py' in this folder before running this installer."
  deactivate
  exit 1
fi

# Ensure models folder exists
mkdir -p models

# Launch app
echo "[🚀] Launching RA-7 Conscious Assistant..."
python3 conscious_desktop_assistant.py

echo "--------------------------------------------"
echo "✅ RA-7 Assistant completed."
deactivate
