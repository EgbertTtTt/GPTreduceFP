import os
import json
from collections import defaultdict

def process_smartbugs_json(smartbugs_dir, reference_json_path, output_json_path):
    # 用于统计 SWC category 的计数器
    swc_category_count = defaultdict(int)
    
    # 加载参考的 JSON 文件
    with open(reference_json_path, 'r') as ref_file:
        reference_data = json.load(ref_file)

    # 遍历指定目录中的所有 smartbugs.json 文件
    for root, dirs, files in os.walk(smartbugs_dir):
        for file in files:
            if file == 'smartbugs.json':
                smartbugs_file_path = os.path.join(root, file)
                with open(smartbugs_file_path, 'r') as smartbugs_file:
                    smartbugs_data = json.load(smartbugs_file)

                    # 提取 "filename" 项的值，并去掉前缀 "Dapp_dataset/positive/"
                    if "filename" in smartbugs_data:
                        full_filename = smartbugs_data["filename"]
                        if full_filename.startswith("Dapp_dataset/positive/"):
                            relative_filename = full_filename[len("Dapp_dataset/positive/"):]
                            
                            # 在参考JSON中查找对应的文件地址
                            if relative_filename in reference_data:
                                swc_entries = reference_data[relative_filename].get("SWCs", [])
                                
                                # 提取每个 SWC 中的 "category" 并计数
                                for swc in swc_entries:
                                    category = swc.get("category", "Unknown")
                                    swc_category_count[category] += 1

    # 将统计结果输出到一个新JSON文件
    with open(output_json_path, 'w') as output_file:
        json.dump(swc_category_count, output_file, indent=4)

    print(f"统计结果已保存到 {output_json_path}")

# 使用示例
smartbugs_directory = "Dapp_ToolResult/solhint-3.3.8/20240909_1255/Dapp_dataset/positive"
reference_json_file = "vul_info/filtered_vul_exist_info.json"
output_json_file = "scripts/tool_result_check/solhint/solhint_SWCname.json"

process_smartbugs_json(smartbugs_directory, reference_json_file, output_json_file)
