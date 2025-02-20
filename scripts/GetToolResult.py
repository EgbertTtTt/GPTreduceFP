import os
import json

def find_result_files(root_dir):
    """
    Recursively search for all 'result.json' files in the given root directory.

    Args:
        root_dir (str): The root directory to start searching from.

    Returns:
        list: A list of file paths to all 'result.json' files found.
    """
    result_files = []
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file == "result.json":
                result_files.append(os.path.join(root, file))
    return result_files

def extract_findings(result_files):
    """
    Extract findings from a list of 'result.json' files. If 'findings' is empty in a result.json,
    attempt to extract information from 'smartbugs.json' in the same directory.

    Args:
        result_files (list): A list of file paths to 'result.json' files.

    Returns:
        list: A list of dictionaries containing 'filename' and 'name' extracted from the findings.
    """
    findings_list = []
    for result_file in result_files:
        try:
            with open(result_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                findings = data.get("findings", [])
                if findings:
                    for finding in findings:
                        findings_list.append({
                            "filename": finding.get("filename"),
                            "vulnerability": finding.get("name")
                        })
                else:
                    # If findings is empty, look for smartbugs.json in the same directory
                    smartbugs_file = os.path.join(os.path.dirname(result_file), "smartbugs.json")
                    if os.path.exists(smartbugs_file):
                        with open(smartbugs_file, 'r', encoding='utf-8') as sf:
                            smartbugs_data = json.load(sf)
                            filename = smartbugs_data.get("filename")
                            findings_list.append({
                                "filename": filename,
                                "vulnerability": None
                            })
        except Exception as e:
            print(f"Error reading {result_file}: {e}")
    return findings_list

def save_findings_to_json(findings_list, output_file):
    """
    Save the extracted findings to a JSON file.

    Args:
        findings_list (list): A list of dictionaries containing 'filename' and 'name' to save.
        output_file (str): The output file path where findings will be saved.
    """
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(findings_list, f, indent=4, ensure_ascii=False)
        print(f"Findings successfully saved to {output_file}")
    except Exception as e:
        print(f"Error saving to {output_file}: {e}")

def main():
    """
    Main function to drive the script. Prompts the user for the root directory,
    finds all 'result.json' files, extracts relevant findings, and saves them to an output JSON file
    for each subdirectory under the given root directory.
    """
    root_directory = "Dapp_ToolResult"

    for sub_dir in os.listdir(root_directory):
        sub_dir_path = os.path.join(root_directory, sub_dir)
        if os.path.isdir(sub_dir_path):
            result_files = find_result_files(sub_dir_path)
            if not result_files:
                print(f"No result.json files found in the directory: {sub_dir_path}")
                continue

            findings_list = extract_findings(result_files)
            path = os.path.join('Dapp_ToolResult_Merge', sub_dir)
            os.makedirs(path)
            output_file = f"Dapp_ToolResult_Merge/{sub_dir}/{sub_dir}.json"
            save_findings_to_json(findings_list, output_file)

if __name__ == "__main__":
    main()
