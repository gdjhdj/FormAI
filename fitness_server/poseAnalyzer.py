import os
from os import remove
from pathlib import Path
import cv2
import mediapipe as mp
import numpy as np
from sklearn.cluster import KMeans
from fitnessDB import exercise_phases, key_phases
from feedBack import getWeightLiftingFeedback

class PoseAnalyzer:
    def __init__(self, exercise=None):
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose(
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5
        )
        self.mp_drawing = mp.solutions.drawing_utils 
        self.last_known_position = {}
        self.exercise = exercise
        self.knee_angle = True  # Flag to control knee angle calculation

    def get_landmark_coordinates(self, landmarks, index): 
        if landmarks:
            landmark = landmarks[index]
            if landmark.visibility > 0.5:
                self.last_known_position[index] = (landmark.x, landmark.y, landmark.z)
                return self.last_known_position[index]
        return self.last_known_position.get(index, None)
        
    def calculate_angle(self, a, b, c):
        if a is None or b is None or c is None:
            # Return None if any of the points are missing
            return None

        a, b, c = np.array(a), np.array(b), np.array(c)
        ba, bc = a - b, c - b
        cosine_angle = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc))
        angle = np.degrees(np.arccos(np.clip(cosine_angle, -1.0, 1.0)))
        return round(angle, 2)

    def process_frame(self, frame, results):
        angle_dict = {}
        landmarks = results.pose_landmarks.landmark

        left_shoulder = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_SHOULDER.value)
        left_elbow = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_ELBOW.value)   
        left_wrist = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_WRIST.value)
        left_hip = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_HIP.value)
        left_knee = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_KNEE.value)
        left_ankle = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_ANKLE.value)
        left_thumb = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_THUMB.value)
        left_index_finger = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.LEFT_INDEX.value)

        right_shoulder = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_SHOULDER.value)
        right_elbow = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_ELBOW.value)   
        right_wrist = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_WRIST.value)
        right_hip = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_HIP.value)
        right_knee = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_KNEE.value)
        right_ankle = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_ANKLE.value)
        right_thumb = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_THUMB.value)
        right_index_finger = self.get_landmark_coordinates(landmarks, self.mp_pose.PoseLandmark.RIGHT_INDEX.value)

        angle_dict["l_elbow"] = self.calculate_angle(left_shoulder, left_elbow, left_wrist)
        angle_dict["l_shoulder"] = self.calculate_angle(left_hip, left_shoulder, left_elbow)
        angle_dict["l_wrist"] = self.calculate_angle(left_elbow, left_wrist, left_index_finger)
        if self.knee_angle:
            angle_dict["l_knee"] = self.calculate_angle(left_hip, left_knee, left_ankle)
            
        angle_dict["r_elbow"] = self.calculate_angle(right_shoulder, right_elbow, right_wrist)
        angle_dict["r_shoulder"] = self.calculate_angle(right_hip, right_shoulder, right_elbow)
        angle_dict["r_wrist"] = self.calculate_angle(right_elbow, right_wrist, right_index_finger)
        if self.knee_angle:
            angle_dict["r_knee"] = self.calculate_angle(right_hip, right_knee, right_ankle)

        self.mp_drawing.draw_landmarks(frame, results.pose_landmarks, self.mp_pose.POSE_CONNECTIONS)
        self.write_angles(angle_dict, frame)
        return angle_dict if any(angle is not None for angle in angle_dict.values())  else None

    def get_angles(self, remove_video, show_video, video_path):
        video_path = self.convert_mp4(video_path, remove_original=remove_video)
        cap = cv2.VideoCapture(video_path)
        angle_list = []
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frame_rgb = np.ascontiguousarray(frame_rgb)
            results = self.pose.process(frame_rgb)
            if results.pose_landmarks:
                angle_dict = self.process_frame(frame, results)
                if angle_dict:
                    angle_list.append(angle_dict)
            if show_video:
                cv2.imshow('Frame', frame)
            if cv2.waitKey(10) & 0xFF == ord('q'): 
                break
        cap.release()
        cv2.destroyAllWindows()
        return angle_list, video_path

    def write_angles(self, angle_dict, frame):
        cv2.putText(frame, f'Left Elbow: {angle_dict["l_elbow"]} deg', (30, 50),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,255,0), 2)
        cv2.putText(frame, f'Right Elbow: {angle_dict["r_elbow"]} deg', (30, 80),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,255,0), 2)
        cv2.putText(frame, f'Left Shoulder: {angle_dict["l_shoulder"]} deg', (30, 110),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,0,0), 2)
        cv2.putText(frame, f'Right Shoulder: {angle_dict["r_shoulder"]} deg', (30, 140),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,0,0), 2)
        cv2.putText(frame, f'Left Wrist: {angle_dict["l_wrist"]} deg', (30, 170),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,0,255), 2)
        cv2.putText(frame, f'Right Wrist: {angle_dict["r_wrist"]} deg', (30, 200),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0,0,255), 2)
        
    def analyze_weightlifting_video(self, video_path, remove_video = False, show_video = False):
        angle_list, video_path = self.get_angles(remove_video, show_video, video_path)
        print("Angle list:", angle_list)  # Debug print
        if not angle_list:
            raise ValueError("No angles were detected in the video")
            
        key_phases = self.extract_movement_phases(angle_list)
        print("Extracted key phases:", key_phases)  # Debug print
        middle_angles = self.extract_middle_portion(angle_list, portion = 0.3)
        print("Middle angles:", middle_angles)  # Debug print
        
        if remove_video:
            remove(video_path)
        return{
            "key phases (k-means)": key_phases.tolist(),
            "movements": middle_angles
        }

    def convert_mp4(self, path, remove_original = False):
        _, extension = os.path.splitext(path)
        extension = extension.lower()
        if extension == '.mov':
            video_output = Path(path).stem + '.mp4'
            print(path, video_output)
            os.popen(f'ffmpeg -i "{path}" "{video_output}"').read()
            if remove_original:
                remove(path)
            return video_output
        return path
        
    def fetch_weight_lifting_feedback(self, video_path, remove_video = False, show_video = False):
        angle_result = self.analyze_weightlifting_video(video_path, remove_video, show_video)
        print("Angle result:", angle_result)  # Debug print
        exercise_key_phases = key_phases.get(self.exercise, ["Start", "Middle", "End"])
        print("Exercise:", self.exercise)  # Debug print
        print("Key phases:", exercise_key_phases)  # Debug print
        feedback = getWeightLiftingFeedback(angles = angle_result, exercise = self.exercise, key_phases = exercise_key_phases)
        return feedback
        
    def fetch_basketball_feedback(self, video_path, remove_video = False, show_video = False):
        angle_result = self.get_angles(video_path = video_path, remove_video = remove_video, show_video = show_video)
        feedback = getBasketballFeedback(angles_list = angle_result)
        return feedback

    def extract_movement_phases(self, angle_list): 
        filtered_angles = []
        for d in angle_list:
            angles = [
                d.get("l_elbow", np.nan), d.get("l_shoulder", np.nan), d.get("l_wrist", np.nan), 
                d.get("r_elbow", np.nan), d.get("r_shoulder", np.nan), d.get("r_wrist", np.nan)
            ]
            filtered_angles.append(angles)
        angle_array = np.array(filtered_angles)

        if len(angle_array) == 0:
            raise ValueError("no valid data points, for clustering")
        col_means = np.nanmean(angle_array, axis = 0)
        inds= np.where(np.isnan(angle_array))
        angle_array[inds] = np.take(col_means, inds[1])

        n_clusters = exercise_phases.get(self.exercise, 4)
        kmeans = KMeans(n_clusters = n_clusters, random_state = 42, n_init = 10)
        kmeans.fit(angle_array)
        return kmeans.cluster_centers_

    def extract_middle_portion(self, angle_list, portion = 0.3):
        total_frames = len(angle_list)
        start_idx = int(total_frames * (1-portion)/2)
        end_idx = min(start_idx + 15, total_frames)
        return angle_list[start_idx: end_idx]

if __name__ == "__main__":
    # video_path = "sample/military_press_short.mp4"
    # analyzer = PoseAnalyzer(exercise="Military Press")
    # # result = analyzer.analyze_video(video_path)
    # # print(result)
    # feedback = analyzer.fetch_weight_lifting_feedback(video_path)
    # print(feedback)

    video_path = "sample/basketball_throw.mp4"
    analyzer = PoseAnalyzer(exercise="Basketball Throw")
    feedback = analyzer.fetch_basketball_feedback(video_path)
    print(feedback)
    #write code to run analyzer