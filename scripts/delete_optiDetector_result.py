import os
import json

def process_json_file(file_path):
    # 读取result.json文件
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # 保留待删除的findings项
    findings_to_remove = [finding for finding in data.get('findings', []) if finding['category'] in ['best-practice', 'performance']]
    
    # 过滤掉'best-practice' 和 'performance' 类别的项
    data['findings'] = [finding for finding in data.get('findings', []) if finding['category'] not in ['best-practice', 'performance']]

    # 如果有需要删除的项，写入新的json文件
    if findings_to_remove:
        # 定义固定的输出目录
        output_dir = 'scripts/optiDetector_result'
        # 创建输出文件夹，如果不存在的话
        os.makedirs(output_dir, exist_ok=True)
        # 生成输出文件的路径，使用原始文件路径结构作为文件名的一部分
        output_file_path = os.path.join(output_dir, os.path.basename(file_path).replace('result.json', 'semgrep_removed_findings.json'))

        # 将删除的项写入新文件
        with open(output_file_path, 'w', encoding='utf-8') as f:
            json.dump(findings_to_remove, f, indent=4, ensure_ascii=False)
        
        print(f"Removed findings saved to: {output_file_path}")

    # 将修改后的result.json文件保存回原文件
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

def process_directory(directory):
    # 遍历所有子文件夹
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file == 'result.json':
                file_path = os.path.join(root, file)
                print(f"Processing: {file_path}")
                process_json_file(file_path)

if __name__ == "__main__":
    # 输入要遍历的目录
    input_directory = "Dapp_ToolResult/semgrep"
    process_directory(input_directory)
