import json
from collections import Counter

# Function to load JSON data from a file
def load_json_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

# Function to count the number of items for each key
def count_items_in_json(data):
    counts = {key: len(value) for key, value in data.items()}
    return sorted(counts.items(), key=lambda item: item[1], reverse=True)

# Example usage
file_path = 'vul_info/filtered_categorized_vul_info.json'  # Replace with the path to your JSON file
json_data = load_json_data(file_path)
counts = count_items_in_json(json_data)

# Display the counts
for key, count in counts:
    print(f'{key}: {count}')
