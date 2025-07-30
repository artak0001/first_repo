#!/bin/bash

# Script to run the Log Archive Web Interface

echo "Starting Log Archive Web Interface..."
echo "========================================="

# Check if virtual environment exists
if [ ! -d "log_archive_env" ]; then
    echo "Creating virtual environment..."
    python3 -m venv log_archive_env
    
    echo "Installing dependencies..."
    source log_archive_env/bin/activate
    pip install -r requirements.txt
fi

# Activate virtual environment and run the app
echo "Activating virtual environment and starting Flask app..."
source log_archive_env/bin/activate
echo "Flask app will be available at: http://localhost:5000"
echo "Press Ctrl+C to stop the server"
echo "========================================="

python app.py