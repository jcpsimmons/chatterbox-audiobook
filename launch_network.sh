#!/bin/bash

# Performance and Debugging Section
# =================================
# Enable CUDA_LAUNCH_BLOCKING for detailed error reports, but it hurts performance.
# export CUDA_LAUNCH_BLOCKING=1
# export TORCH_USE_CUDA_DSA=1

echo "Checking for virtual environment..."
if [ ! -f "venv/bin/activate" ]; then
    echo "ERROR: Virtual environment not found!"
    echo "Please run ./install-audiobook.sh first to set up the environment."
    echo
    echo "Make sure you're in the chatterbox repository directory."
    read -p "Press Enter to exit..."
    exit 1
fi

echo "Checking repository structure..."
if [ ! -f "gradio_tts_app_audiobook.py" ]; then
    echo "ERROR: gradio_tts_app_audiobook.py not found!"
    echo "Please make sure you're in the chatterbox repository root."
    read -p "Press Enter to exit..."
    exit 1
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo
echo "Starting Chatterbox TTS Audiobook Edition (NETWORK MODE)..."
echo "Features: Voice Library, Character Management, Audiobook Tools"
echo "Audio Cleaning Available in \"Clean Samples\" Tab"
echo
echo "SECURITY MODE: LOCAL NETWORK ACCESS"
echo "- Accessible from other devices on your local network"
echo "- No public sharing enabled"
echo "- Find your local IP address and use port 7860"
echo "- Example: http://192.168.1.100:7860"
echo
echo "This may take a moment to load the models..."
echo
echo "Current directory: $(pwd)"
echo "Python environment: $VIRTUAL_ENV"
echo "Voice library will be created at: $(pwd)/voice_library"
echo

# Get local IP address for display
LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || ip route get 8.8.8.8 | awk '{print $7; exit}' 2>/dev/null || echo "Unable to determine IP")
echo "Access URL: http://$LOCAL_IP:7860"

python launchers/launch_network_app.py

echo
echo "Chatterbox TTS Audiobook Edition (NETWORK MODE) has stopped."
echo "Deactivating virtual environment..."
deactivate
echo
echo "Thanks for using Chatterbox TTS Audiobook Edition! 🎧✨"
echo "Your voice profiles are saved in the voice_library folder."
echo "Audio cleaning features are in the \"Clean Samples\" tab!"
read -p "Press Enter to continue..."