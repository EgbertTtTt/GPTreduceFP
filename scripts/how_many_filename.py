import json
import os
from collections import Counter

def count_unique_filenames(json_file_path):
    if not os.path.exists(json_file_path):
        print(f"File {json_file_path} does not exist.")
        return

    try:
        with open(json_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except json.JSONDecodeError:
        print(f"Failed to parse JSON from file {json_file_path}.")
        return

    filename_counter = Counter()
    
    # Traverse through the JSON structure
    def traverse_json(data):
        if isinstance(data, dict):
            for key, value in data.items():
                if key == "filename":
                    filename_counter[value] += 1
                else:
                    traverse_json(value)
        elif isinstance(data, list):
            for item in data:
                traverse_json(item)

    traverse_json(data)
    
    # Print the count of unique filenames
    unique_filenames = len(filename_counter)
    print(f"There are {unique_filenames} unique 'filename' values in the JSON file.")

if __name__ == "__main__":
    json_file_path = 'Dapp_ToolResult_Merge/semgrep/semgrep.json'
    count_unique_filenames(json_file_path)
