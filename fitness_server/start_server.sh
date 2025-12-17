#!/bin/bash

# Fitness Server Startup Script
# This script helps you start the Flask server for the fitness app

echo "Starting Fitness Server..."
echo "=========================="

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if virtual environment exists
if [ -d "../venv" ]; then
    echo "Activating virtual environment..."
    source ../venv/bin/activate
else
    echo "Warning: Virtual environment not found at ../venv"
    echo "Please ensure you have a virtual environment set up with required packages."
fi

# Check if required Python packages are installed
echo "Checking dependencies..."
python3 -c "import flask, flask_cors, cv2, mediapipe, numpy, sklearn" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Error: Required packages not installed."
    echo "Please install: flask flask-cors opencv-python mediapipe numpy scikit-learn"
    exit 1
fi

# Get the local IP address
echo ""
echo "Your server will be accessible at:"
echo "  Local: http://localhost:5001"
echo "  Network: http://$(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}'):5001"
echo ""
echo "Make sure your Flutter app uses the correct IP address!"
echo ""
echo "Starting server on port 5001..."
echo "Press Ctrl+C to stop the server"
echo "=========================="
echo ""

# Start the server
python3 server.py


