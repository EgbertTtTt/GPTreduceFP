import json
from collections import defaultdict

def calculate_average_code_segment_length(json_file):
    # 读取 JSON 文件
    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # 使用字典来存储每个 vulnerability 的代码段长度总和和计数
    vulnerability_lengths = defaultdict(lambda: {"total_length": 0, "count": 0})
    
    # 遍历 JSON 数据
    for entry in data:
        vulnerability = entry.get("vulnerability")
        code_segment = entry.get("code_segment", "")
        code_length = len(code_segment)
        
        # 累加每个 vulnerability 的代码段长度和计数
        vulnerability_lengths[vulnerability]["total_length"] += code_length
        vulnerability_lengths[vulnerability]["count"] += 1
    
    # 计算并输出每个 vulnerability 的平均代码段长度
    average_lengths = {}
    for vulnerability, values in vulnerability_lengths.items():
        average_length = values["total_length"] / values["count"] if values["count"] > 0 else 0
        average_lengths[vulnerability] = average_length
    
    return average_lengths

# 示例用法
json_file = 'Openai_api_experiment/GPT_results/sfuzz/sfuzz_ver2.1.json'
average_lengths = calculate_average_code_segment_length(json_file)

# 输出结果
for vulnerability, avg_length in average_lengths.items():
    print(f"Vulnerability: {vulnerability}, Average Code Segment Length: {avg_length:.2f}")
