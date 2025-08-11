#!/bin/bash
echo "========================================"
echo "   Chatterbox TTS - Installation Setup"
echo "========================================"
echo
echo "This will install Chatterbox TTS in a virtual environment"
echo "to keep it isolated from other Python projects."
echo
echo "Requirements:"
echo "- Python 3.10 or higher"
echo "- NVIDIA GPU with CUDA support (recommended)"
echo "- Git (if you want to pull updates)"
echo
echo "Current directory: $(pwd)"
echo
read -p "Press Enter to continue..."

echo
echo "[1/9] Checking Python installation..."
python3 --version
if [ $? -ne 0 ]; then
    echo "ERROR: Python is not installed or not in PATH"
    echo "Please install Python 3.10+ from your package manager:"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-pip python3-venv"
    echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
    echo "  Arch: sudo pacman -S python python-pip"
    read -p "Press Enter to exit..."
    exit 1
fi

echo
echo "[2/9] Checking if we're in the correct directory..."
if [ ! -f "pyproject.toml" ]; then
    echo "ERROR: pyproject.toml not found!"
    echo "Please make sure you're running this from the chatterbox repository root."
    echo "Expected files: pyproject.toml, gradio_tts_app.py, src/chatterbox/"
    read -p "Press Enter to exit..."
    exit 1
fi

if [ ! -d "src/chatterbox" ]; then
    echo "ERROR: src/chatterbox directory not found!"
    echo "Please make sure you're in the correct chatterbox repository."
    read -p "Press Enter to exit..."
    exit 1
fi

echo "Repository structure verified ✓"

echo
echo "[3/9] Creating virtual environment..."
if [ -d "venv" ]; then
    echo "Virtual environment already exists. Removing old one..."
    rm -rf venv
fi
python3 -m venv venv

echo
echo "[4/9] Activating virtual environment..."
source venv/bin/activate

echo
echo "[5/9] Upgrading pip..."
python -m pip install --upgrade pip

echo
echo "[6/9] Installing compatible PyTorch with CUDA support..."
echo "This may take a while (downloading ~2.5GB)..."
echo "Installing PyTorch 2.4.1 + torchvision 0.19.1 (compatible versions)..."
pip install torch==2.4.1+cu121 torchvision==0.19.1+cu121 torchaudio==2.4.1+cu121 --index-url https://download.pytorch.org/whl/cu121

echo
echo "[7/9] Installing Chatterbox TTS and dependencies..."
pip install -e .
pip install gradio

echo
echo "[8/9] Installing and configuring pydantic (tested version)..."
echo "Uninstalling any existing pydantic versions..."
pip uninstall pydantic -y
echo "Installing pydantic version 2.10.6 (tested and verified)..."
pip install pydantic==2.10.6
echo "Verifying pydantic installation..."
pip show pydantic | grep "Version: 2.10.6"
if [ $? -ne 0 ]; then
    echo "WARNING: Pydantic 2.10.6 installation may have issues."
    echo "Attempting alternative installation..."
    pip install pydantic==2.10.6 --force-reinstall
fi

echo "Installing numpy (compatible version)..."
pip install numpy==1.26.0 --force-reinstall

echo
echo "[9/9] Testing installation..."
echo "Testing PyTorch and CUDA..."
python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"

if [ $? -ne 0 ]; then
    echo "WARNING: PyTorch test failed. Trying to fix torchvision compatibility..."
    pip uninstall torchvision -y
    pip install torchvision==0.19.1+cu121 --index-url https://download.pytorch.org/whl/cu121 --force-reinstall
    echo "Retesting..."
    python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"
fi

echo
echo "Testing Chatterbox import..."
python -c "from chatterbox.tts import ChatterboxTTS; print('Chatterbox TTS imported successfully!')"

if [ $? -ne 0 ]; then
    echo "WARNING: Chatterbox import failed. This might be a dependency issue."
    echo "The installation will continue, but you may need to troubleshoot."
    echo "Common fixes:"
    echo "1. Run install-audiobook.sh again"
    echo "2. Check NVIDIA drivers are up to date"
    echo "3. Restart your computer"
fi

echo
echo "Testing pydantic compatibility..."
python -c "import pydantic; print('Pydantic version:', pydantic.__version__)"

echo
echo "========================================"
echo "        Installation Complete!"
echo "========================================"
echo
echo "Virtual environment created at: $(pwd)/venv"
echo

echo "Final system check..."
python -c "import torch; print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'None')"

echo
echo "========================================"
echo "           Ready for Audiobooks!"
echo "========================================"
echo
echo "To start Chatterbox TTS:"
echo "1. Run ./launch_audiobook.sh (recommended)"
echo "2. Or manually: source venv/bin/activate then python gradio_tts_app_audiobook.py"
echo
echo "Perfect for:"
echo "- Voice cloning for audiobook narration"
echo "- Multiple character voices"
echo "- Consistent voice quality across chapters"
echo "- Professional audiobook production"
echo
echo "Note: If you encounter pydantic compatibility issues later,"
echo "you can run ./update.sh to specifically update pydantic."
echo
echo "Installation finished successfully!"
read -p "Press Enter to continue..."