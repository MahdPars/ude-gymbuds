import cv2
import mediapipe as mp
import numpy as np
import pandas as pd
import os
from moviepy.editor import VideoFileClip
from moviepy.video.fx import all as vfx

# Initialize mediapipe for pose estimation
mp_pose = mp.solutions.pose
pose  = mp_pose.Pose(static_image_mode=False, model_complexity=1, min_detection_confidence=0.5, min_tracking_confidence=0.5)

# Helper Functions: Preprocessing
def calculate_angle(a, b, c):
    a = np.array(a)  # First
    b = np.array(b)  # Mid
    c = np.array(c)  # End
    
    radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
    angle = np.abs(radians*180.0/np.pi)
    
    if angle > 180.0:
        angle = 360-angle
        
    return angle 

def calculate_distance(point1, point2):
    return np.linalg.norm(np.array(point1) - np.array(point2))

def calculate_relative_position(reference, target):
    # Calculate the relative position of the target joint with respect to the reference joint
    relative_position = np.array(target) - np.array(reference)
    return relative_position.tolist()

def process_video_for_squat(video_path):
    cap = cv2.VideoCapture(video_path)
    feature_rows = []

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = pose.process(frame_rgb)

        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark
            
            # Define keypoints
            shoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
            hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
            knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y]
            ankle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x, landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y]


            # Reference distance (e.g., hip to shoulder)
            ref_distance = calculate_distance(hip, shoulder)

            # Calculate distances
            knee_to_ankle_distance = calculate_distance(knee, ankle)
            hip_to_floor_distance = calculate_distance(hip, [hip[0], 1])  # Simplified floor distance

            # Calculate relative positions
            knee_rel_to_ankle = calculate_relative_position(knee, ankle)
            ankle_rel_to_ankle = calculate_relative_position(ankle, ankle)
            hip_rel_to_ankle = calculate_relative_position(hip, ankle)

            # Calculate angles
            knee_angle = calculate_angle(hip, knee, ankle)
            hip_angle = calculate_angle(shoulder, hip, knee)

            # Append to feature rows
            feature_rows.append([
                knee_angle, hip_angle, 
                knee_to_ankle_distance, hip_to_floor_distance,
                hip_rel_to_ankle[0], hip_rel_to_ankle[1], 
                knee_rel_to_ankle[0], knee_rel_to_ankle[1], 
                ankle_rel_to_ankle[0], ankle_rel_to_ankle[1]
            ])

    cap.release()

    # Define columns for DataFrame
    columns = [
        'knee_angle', 'hip_angle', 
        'knee_to_ankle_distance', 'hip_to_floor_distance', 
        'hip_rel_x', 'hip_rel_y',
        'knee_rel_x', 'knee_rel_y', 
        'ankle_rel_x', 'ankle_rel_y'
    ]
    return pd.DataFrame(feature_rows, columns=columns)

def calculate_thigh_to_floor_angle(hip, knee):
    # Assuming the floor is parallel to the x-axis of the frame
    # and the y-coordinate increases from top to bottom:
    # A horizontal line through the knee has the same y-coordinate as the knee
    # The x-coordinate can be any value that is not the x-coordinate of the knee
    # (for example, knee[0] + 1 to make a horizontal line to the right)
    horizontal = (knee[0] + 1, knee[1])
    
    # Use the calculate_angle function you defined earlier
    angle = calculate_angle(hip, knee, horizontal)
    
    # Since we want the angle relative to the floor, we subtract it from 90 degrees
    # This is because the pose estimation gives the angle with respect to the horizontal,
    # but we want the complement to that angle (the thigh's lift from the horizontal)
    thigh_to_floor_angle = 90 - angle
    
    return thigh_to_floor_angle

# DATA CLEANING:
def clean_df(squat_df):
    squat_df_cleaned = squat_df.dropna()

    # 2. Smoothing Data
    # Apply a simple moving average with a window size you find appropriate
    window_size = 4  # Example window size
    squat_df_cleaned['thigh_to_floor_angle_smooth'] = squat_df_cleaned['thigh_to_floor_angle'].rolling(window=window_size).mean()
    squat_df_cleaned['hip_rel_x'] = squat_df_cleaned['hip_rel_x'].rolling(window=window_size).mean()
    squat_df_cleaned['hip_rel_y'] = squat_df_cleaned['hip_rel_y'].rolling(window=window_size).mean()
    squat_df_cleaned['knee_rel_x'] = squat_df_cleaned['knee_rel_x'].rolling(window=window_size).mean()
    squat_df_cleaned['knee_rel_y'] = squat_df_cleaned['knee_rel_y'].rolling(window=window_size).mean()

    # 3. Removing Outliers
    # Simple statistical method
    # Assume that any data point outside of 3 standard deviations is an outlier
    threshold = 3
    angle_mean = squat_df_cleaned['thigh_to_floor_angle_smooth'].mean()
    angle_std = squat_df_cleaned['thigh_to_floor_angle_smooth'].std()

    outliers = (squat_df_cleaned['thigh_to_floor_angle_smooth'] < angle_mean - threshold * angle_std) | (squat_df_cleaned['thigh_to_floor_angle_smooth'] > angle_mean + threshold * angle_std)
    squat_df_cleaned = squat_df_cleaned[~outliers]
    hip_x_mean = squat_df_cleaned['hip_rel_x'].mean()
    hip_x_std = squat_df_cleaned['hip_rel_x'].std()
    hip_y_mean = squat_df_cleaned['hip_rel_y'].mean()
    hip_y_std = squat_df_cleaned['hip_rel_y'].std()
    knee_x_mean = squat_df_cleaned['knee_rel_x'].mean()
    knee_x_std = squat_df_cleaned['knee_rel_x'].std()
    knee_y_mean = squat_df_cleaned['knee_rel_y'].mean()
    knee_y_std = squat_df_cleaned['knee_rel_y'].std()

    outliers = (squat_df_cleaned['hip_rel_x'] < hip_x_mean - threshold * hip_x_std) | (squat_df_cleaned['hip_rel_x'] > hip_x_mean + threshold * hip_x_std)
    squat_df_cleaned = squat_df_cleaned[~outliers]
    outliers = (squat_df_cleaned['hip_rel_y'] < hip_y_mean - threshold * hip_y_std) | (squat_df_cleaned['hip_rel_y'] > hip_y_mean + threshold * hip_y_std)
    squat_df_cleaned = squat_df_cleaned[~outliers]
    outliers = (squat_df_cleaned['knee_rel_x'] < knee_x_mean - threshold * knee_x_std) | (squat_df_cleaned['knee_rel_x'] > knee_x_mean + threshold * knee_x_std)
    squat_df_cleaned = squat_df_cleaned[~outliers]
    outliers = (squat_df_cleaned['knee_rel_y'] < knee_y_mean - threshold * knee_y_std) | (squat_df_cleaned['knee_rel_y'] > knee_y_mean + threshold * knee_y_std)
    squat_df_cleaned = squat_df_cleaned[~outliers]

    angle_change_threshold = 1.25  # Degrees

    # Calculate the change in angle between consecutive frames
    squat_df_cleaned['thigh_angle_change'] = squat_df_cleaned['thigh_to_floor_angle'].diff().abs()

    # Filter rows where the change is above the threshold
    active_squat_df = squat_df_cleaned[squat_df_cleaned['thigh_angle_change'] > angle_change_threshold]
    return active_squat_df

# SCORING

def identify_bottom_phase(squat_data, window_size=5):
    # Find the index of the maximum thigh-to-floor angle, which should correspond to the deepest squat position
    squat_data.reset_index(drop=True,inplace=True)
    max_angle_index = squat_data['thigh_to_floor_angle_smooth'].idxmax()

    # Define the window around the max angle for the bottom phase
    # Ensure the window doesn't go beyond the DataFrame bounds
    start_index = max(max_angle_index - window_size, 0)
    end_index = min(max_angle_index + window_size, len(squat_data) - 1)

    # Extract the bottom phase data using the defined window
    bottom_phase_data = squat_data.iloc[start_index:end_index + 1]  # +1 because the upper bound is exclusive
    
    return bottom_phase_data

def score_depth(squat_data, tolerance, window_size=2):
    # Identify the bottom phase of the squat
    bottom_data = identify_bottom_phase(squat_data, window_size)
    print("Bottom Data:", bottom_data['thigh_to_floor_angle_smooth'])

    # Proceed with scoring if bottom_data is not empty
    if not bottom_data.empty:
        # Good depth is indicated by angles greater than 90 degrees - tolerance
        # and less than or equal to 90 degrees + tolerance
        depth_criteria_met = ((90 - tolerance) <= bottom_data['thigh_to_floor_angle_smooth']) & \
                             (bottom_data['thigh_to_floor_angle_smooth'] <= (90 + tolerance))
        print("Depth Criteria Met:", depth_criteria_met)  # Debug statement

        # Calculate the depth score as the proportion of frames meeting the depth criteria
        depth_score = (depth_criteria_met.sum() / len(bottom_data)) * 100
        print("Depth Score:", depth_score)  # Debug statement
    else:
        # Handle cases where the bottom phase data is empty
        depth_score = 0

    return depth_score



def score_ascent(squat_data, lower_threshold, upper_threshold):
    if not squat_data.empty and 'thigh_to_floor_angle' in squat_data.columns and not squat_data['thigh_to_floor_angle'].empty:
        # Calculate the angle change rate for ascent
        squat_data['angle_change'] = -squat_data['thigh_to_floor_angle'].diff()

        # Identify the ascent phase
        if not squat_data['angle_change'].empty:
            bottom_index = squat_data['thigh_to_floor_angle'].idxmax()
            ascent_data = squat_data.loc[bottom_index:]

            # Check if each frame is within the desired power range
            in_range = ascent_data['angle_change'].between(lower_threshold, upper_threshold)

            # Score based on the proportion of frames within the range
            ascent_score = in_range.mean() * 100  # Proportion in range, scaled to percentage
        else:
            ascent_score = 0  # Default score if data is empty
    else:
        ascent_score = 0  # Default score if data is empty or column is missing

    return ascent_score

def score_descent(squat_data, lower_threshold, upper_threshold):
    # Calculate the angle change rate for descent
    squat_data['angle_change'] = squat_data['thigh_to_floor_angle'].diff().abs()
    
    # Identify the descent phase
    try:
        bottom_index = squat_data['thigh_to_floor_angle'].idxmax()
    except ValueError:
        bottom_index = 0
    descent_data = squat_data.loc[:bottom_index]

    # Check if each frame is within the desired speed range
    in_range = descent_data['angle_change'].between(lower_threshold, upper_threshold)

    # Score based on the proportion of frames within the range
    descent_score = in_range.mean() * 100  # Proportion in range, scaled to percentage
    
    return descent_score

def preprocess_score_squat(video_path):
   
   squat_df = process_video_for_squat(video_path)

   squat_df['thigh_to_floor_angle'] = squat_df.apply(
    lambda row: calculate_thigh_to_floor_angle(
        [row['hip_rel_x'], row['hip_rel_y']], 
        [row['knee_rel_x'], row['knee_rel_y']]
    ), axis=1)
   
   if squat_df.any().any():
        # Clean the DataFrame
        squat_df_cleaned = clean_df(squat_df) 
        if squat_df_cleaned.empty:
            print("The DataFrame is empty after cleaning and cannot be scored.")
            return None
        # Apply the scoring functions
        squat_df_cleaned['descent_score'] = score_descent(squat_df_cleaned, -2, 7)
        squat_df_cleaned['depth_score'] = score_depth(squat_df_cleaned, 10)
        squat_df_cleaned['ascent_score'] = score_ascent(squat_df_cleaned, -3, 6)

        return squat_df_cleaned
   else:
        # Handle the empty DataFrame case
        print("The DataFrame is empty and cannot be processed.")
        return None
   
# Relevant Function for Django
def stretch_video_to_10_seconds(input_video_path, output_video_path):
    # Load the video
    video = VideoFileClip(input_video_path)

    # Check if Video is shorter than 10 seconds
    if video.duration < 9:
        # Calculate the new frame rate to stretch the video to 10 seconds
        speed_factor = video.duration / 10

        # Set the new frame rate and write the video
        video.fx(vfx.speedx, speed_factor).write_videofile(output_video_path, codec='libx264')


def preprocess_single_video(video_path, exercise_name):
    stretch_video_to_10_seconds(video_path, video_path)
    print(exercise_name)
    if exercise_name == 'squat':
        squat_df = process_video_for_squat(video_path)

        squat_df['thigh_to_floor_angle'] = squat_df.apply(
            lambda row: calculate_thigh_to_floor_angle(
                [row['hip_rel_x'], row['hip_rel_y']], 
                [row['knee_rel_x'], row['knee_rel_y']]
            ), axis=1
        )
        if squat_df.any().any():
            # Clean the DataFrame
            squat_df_cleaned = clean_df(squat_df)
            squat_df_cleaned['repetition'] = 1 
            if squat_df_cleaned.empty:
                print("The DataFrame is empty after cleaning and cannot be scored.")
                return None
            return squat_df_cleaned
    else: 
        print("The DataFrame is empty and cannot be processed.")
        return None
