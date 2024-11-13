##
#脚本作用：用于收集工具运行结果，有多少成功检测，有多少没能完成检测
##

import os
import json

def collect_results(base_dir):
    summary = {
        "errors_with_values": [],
        "errors_without_values": [],
        "count_with_values": 0,
        "count_without_values": 0
    }

    # Walk through all subdirectories
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file == 'result.json':
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    folder_name = os.path.basename(root)
                    if data.get('errors'):
                        summary["errors_with_values"].append(folder_name)
                        summary["count_with_values"] += 1
                    else:
                        summary["errors_without_values"].append(folder_name)
                        summary["count_without_values"] += 1

    return summary

def write_summary_to_json(summary, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=4)

if __name__ == "__main__":
    base_directory = "test/result/confuzzius/20240905_0905/dataset"  # Update this to your base directory path
    output_json = "summary.json"  # Update this to your desired output file path

    results_summary = collect_results(base_directory)
    write_summary_to_json(results_summary, output_json)
