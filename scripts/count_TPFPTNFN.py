import os
import json

def aggregate_json_data(directory):
    results = {}

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.json'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    try:
                        data = json.load(f)
                        file_results = {
                            "TP": 0,
                            "FP": 0,
                            "TN": 0,
                            "FN": 0
                        }
                        for key, values in data.items():
                            file_results["TP"] += values.get("TP", 0) or 0
                            file_results["FP"] += values.get("FP", 0) or 0
                            file_results["TN"] += values.get("TN", 0) or 0
                            file_results["FN"] += values.get("FN", 0) or 0
                        results[file] = file_results
                    except json.JSONDecodeError as e:
                        print(f"Error decoding JSON in file {file_path}: {e}")

    return results

def main():
    directory = 'check_results_RQ1'
    if not os.path.isdir(directory):
        print("Invalid directory path.")
        return

    file_results = aggregate_json_data(directory)

    for file, stats in file_results.items():
        print(f"Results for {file}:")
        print(f"  TP: {stats['TP']}")
        print(f"  FP: {stats['FP']}")
        print(f"  TN: {stats['TN']}")
        print(f"  FN: {stats['FN']}")
        print()

if __name__ == "__main__":
    main()
