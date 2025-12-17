# Fitness Server

This is the backend server for the Fitness App that analyzes workout videos using pose estimation.

## Setup

1. **Activate the virtual environment:**
   ```bash
   source ../venv/bin/activate
   ```

2. **Install dependencies (if not already installed):**
   ```bash
   pip install flask flask-cors opencv-python mediapipe numpy scikit-learn
   ```

## Running the Server

### Option 1: Use the startup script
```bash
chmod +x start_server.sh
./start_server.sh
```

### Option 2: Run directly
```bash
python3 server.py
```

The server will start on **port 5001** and listen on all interfaces (`0.0.0.0`).

## Finding Your IP Address

Your server IP address is needed for the Flutter app to connect. To find it:

**On macOS:**
```bash
ipconfig getifaddr en0
```

**On Linux:**
```bash
hostname -I | awk '{print $1}'
```

**On Windows:**
```cmd
ipconfig | findstr IPv4
```

Update the IP address in `my_flutter_app/lib/screens/InfoUpload.dart` if it changes.

## Troubleshooting Connection Issues

If you get "Connection refused" errors:

1. **Check if the server is running:**
   - You should see "Starting server on port 5001" in the terminal
   - Visit `http://localhost:5001` in your browser - you should see "Welcome to the Fitness App"

2. **Verify the IP address:**
   - Make sure the IP in your Flutter app matches your computer's current IP
   - Your device and computer must be on the same WiFi network

3. **Check firewall settings:**
   - Make sure port 5001 is not blocked by your firewall
   - macOS: System Settings → Network → Firewall

4. **Test the connection:**
   ```bash
   curl http://YOUR_IP:5001/
   ```
   Should return "Welcome to the Fitness App"

## API Endpoints

- `GET /` - Home page
- `POST /analyzeWeightLifting` - Analyze a weightlifting video
  - Form data: `exercise` (string), `video` (file)
- `POST /analyze_basketball` - Analyze a basketball video
  - Form data: `video` (file)
- `GET /get_weightLifting_videos` - Get list of weightlifting videos
- `GET /get_basketball_videos` - Get list of basketball videos

## Supported Exercises

- bench press
- Overhead Press (military press)
- Lying Triceps Extension
- Deadlift
- Bicep curl
- Pushups
- Sit Ups (sit ups)

Note: Exercise names are case-insensitive and normalized to lowercase.


