#!/bin/bash
# ========================================
#  NOTICE: This functionality has been
#  integrated into install-audiobook.sh
#  This standalone script is kept for
#  emergency pydantic updates only.
# ========================================
echo "========================================"
echo "  Chatterbox TTS - Pydantic Updater"
echo "========================================"
echo
echo "This script will update the pydantic library in your"
echo "existing Chatterbox TTS virtual environment to version 2.10.6"
echo "to resolve potential compatibility issues."
echo
echo "NOTE: This functionality is now integrated into install-audiobook.sh"
echo "This standalone script is for emergency updates only."
echo

echo "Checking for virtual environment..."
if [ ! -f "venv/bin/activate" ]; then
    echo "ERROR: Virtual environment not found!"
    echo "Please make sure this script is in the chatterbox repository root"
    echo "and that you have run ./install-audiobook.sh at least once."
    read -p "Press Enter to exit..."
    exit 1
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo
echo "Uninstalling existing pydantic (if any)..."
pip uninstall pydantic -y

echo
echo "Installing pydantic version 2.10.6..."
pip install pydantic==2.10.6

echo
echo "Verifying pydantic version..."
pip show pydantic | grep "Version: 2.10.6"
if [ $? -ne 0 ]; then
    echo "ERROR: Pydantic 2.10.6 installation failed or was not confirmed."
    echo "Please check the output above for errors."
    echo "You may need to run ./install-audiobook.sh again."
else
    echo "INFO: Pydantic successfully updated to version 2.10.6."
fi

echo
echo "Deactivating virtual environment..."
deactivate

echo
echo "========================================"
echo "         Update Process Complete"
echo "========================================"
echo
echo "You can now try running ./launch_audiobook.sh again."
read -p "Press Enter to continue..."