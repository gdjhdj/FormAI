import os
print("DEBUG: os imported")
from flask import Flask, request, jsonify, send_from_directory
print("DEBUG: Flask imported")
print("DEBUG: Attempting to import PoseAnalyzer...")
from poseAnalyzer import PoseAnalyzer
print("DEBUG: PoseAnalyzer imported")
from flask_cors import CORS
print("DEBUG: CORS imported")
print("DEBUG: Attempting to import fitnessDB...")
from fitnessDB import weightLifting_videos, basketball_videos
print("DEBUG: fitnessDB imported")

app = Flask(__name__)
CORS(app)

os.makedirs("uploads", exist_ok=True)

@app.route("/")
def home():
    return "Welcome to the Fitness App"


@app.route('/get_weightLifting_videos', methods=['GET', 'POST'])
def get_videos():
    return jsonify(weightLifting_videos)

@app.route('/analyzeWeightLifting', methods=['POST'])
def analyze():
    exercise = request.form.get('exercise')
    video = request.files.get('video')

    if not exercise or not video:
        return jsonify({"error": "Exercise and video are required"}), 400
    
    video_path = os.path.join("uploads", video.filename)
    video.save(video_path)

    analyzer = PoseAnalyzer(exercise=exercise)
    try:
        feedback = analyzer.fetch_weight_lifting_feedback(video_path, remove_video=True)
        return jsonify(feedback)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

@app.route('/analyze_basketball', methods=[ 'POST'])
def analyze_basketball():
    video = request.files.get('video')

    if not video:
        return jsonify({"error": "Video is required"}), 400
    
    video_path = os.path.join("uploads", video.filename)
    video.save(video_path)
    analyzer = PoseAnalyzer(exercise="basketball")
    try:
        feedback = analyzer.fetch_basketball_feedback(video_path, remove_video=True)
        return jsonify(feedback)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/get_basketball_videos', methods=['GET', 'POST'])
def get_basketball_videos():
    return jsonify(basketball_videos)

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory('uploads', filename)

if __name__ == '__main__':
    #FOR DEVELOPMENT ONLY USE A PROPER WSGI SERVER FOR PRODUCTION
    app.run(host='0.0.0.0', port=5001, debug=True)
    
    
