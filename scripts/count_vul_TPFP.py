import json
from collections import defaultdict

def count_tp_fp(json_file):
    # 初始化一个字典，用于存储每个 "name" 的 "TP" 和 "FP" 计数
    stats = defaultdict(lambda: {"TP": 0, "FP": 0})
    
    # 打开并读取 JSON 文件
    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # 遍历 JSON 数据
    for item in data:
        name = item.get("name")
        check = item.get("check")
        
        # 如果 "name" 和 "check" 都存在，则统计
        if name and check in ["TP", "FP"]:
            stats[name][check] += 1
    
    # 打印统计结果
    for name, counts in stats.items():
        print(f'Name: {name}, TP: {counts["TP"]}, FP: {counts["FP"]}')

# 使用此函数来统计你需要的json文件
json_file_path = "scripts/tool_result_check/solhint/vulcode.json"
count_tp_fp(json_file_path)
