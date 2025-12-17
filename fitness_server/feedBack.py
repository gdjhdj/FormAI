import json
from openai import OpenAI
with open("key.json", "r") as f:
    key = json.load(f)
client = OpenAI(
    api_key=key["OPENAI_API_KEY"], # This is the default and can be omitted
)

def getWeightLiftingFeedback(angles, exercise, key_phases = None):
    print("Received angles:", angles)  # Debug print
    print("Received exercise:", exercise)  # Debug print
    print("Received key_phases:", key_phases)  # Debug print
    
    prompt = f"""
    provide feedback for my {exercise} video. Act like a {exercise} professional coach.
    I've extracted the following key angles for my right and left elbows, shoulders, and wrists at different movement phases.
    Respond in a structured json format.
    Here's my data, the data is k means clustered, they represent key movement phases
    -{key_phases[0]} 
    -{key_phases[1]} 
    -{key_phases[2]}
    key questions:
    Form feedback:
    -How are my elbows, shoulders, and wrists positioned?
    -Am I exucuting the {exercise} correctly?
    -Did you notice any issues?

    Suggestions for improvement:
    -Does my elbow, shoulder, and wrist position seem accurate?
    -What adjustments can I do to makesure safety and efficiency are as good as possible?

    key angle ranges for a proper form:
    -What are the optimal angle ranges for each movement?
    -How does my angles compare to the ideal pressing mechanics?
    
    The json format should be structured like this:
    """
    json_format = """{
        "Form Feedback": {
            "elbow_position": "<elbow feedback>",
            "shoulder_position": "<shoulder feedback>",
            "wrist_position": "<wrist feedback>"
        },
        "Suggestions for Improvement": {
            "elbow_adjustment": "<elbow adjustment>",
            "shoulder_control": "<shoulder control>",
            "wrist_stability": "<wrist stability>"
        },
        "Key Angle Ranges": {
            "ideal_elbow_range": "<ideal elbow range>",
            "ideal_shoulder_range": "<ideal shoulder range>",
            "ideal_wrist_range": "<ideal wrist range>",
            "your_angles_vs_ideal": "<comparison>"
        }
    }"""
    chat_completion = client.chat.completions.create(
        messages = [
            {"role": "system", "content": prompt + json_format},
            {"role": "user", "content": json.dumps(angles)}
        ],
        model = "gpt-4-1106-preview",
        response_format = {"type": "json_object"},
        max_tokens = 1000
    )
    result = chat_completion.choices[0].message.content
    result = json.loads(result)
    return result

def getBasketballFeedback(angles_list): 
    prompt = """
    provide feedback for my freethrow video. Act like a professional basketball coach.
    Respond in a structured json format.
    Here's my data, the data is k means clustered, it represents joint angles
    
   Provide detailed feedback in Json format in the following structure:


    {
        "BasketballAssessment": {
            "strength": ["List of things the user did well"],
            "improvements": ["List of things the user could improve on"],
            "errors": ["List of things the user did wrong or horribly"]
        }
    }
    This analysis should evaluate fluency, accuracy, posture. Consider factors such as hand, elbow, showder positioning, hip-knee alignment,
    and overall coordination of the motion. If you notice stiff legs, over extention of joints, or general lack of coordination, mention these in the improvements
    or errors.
    If you notice hand motions with good alignment with the ball and basket, good range of motion and consistent angles of hip and knees, mention those in strenght. 
    Makesure improvements are concise, accurate, and do-able.
    """
    response = client.chat.completions.create(
        model = "gpt-4-1106-preview",
        messages = [
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {"type": "text", "text": json.dumps(angles_list)},
                ],
            }
        ],
        response_format = {"type": "json_object"},
    )
    result = response.choices[0].message.content
    result = json.loads(result)
    return result

if __name__ == "__main__": 
    # Example usage
    test_angles = {
        "key phases (k-means)": [[90, 45, 30], [120, 60, 40], [150, 75, 50]],
        "movements": [{"l_elbow": 90, "r_elbow": 85, "l_shoulder": 45, "r_shoulder": 40}]
    }
    feedback = getWeightLiftingFeedback(test_angles, "bench press", key_phases=["start", "middle", "end"])
    print(feedback)