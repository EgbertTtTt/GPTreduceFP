# import json
# from collections import defaultdict

# def count_vulnerability_responses(json_file):
#     # 初始化一个字典，用于存储每个 "vulnerability" 的 "check" 和 "response" 组合的计数
#     stats = defaultdict(lambda: defaultdict(int))
    
#     # 打开并读取 JSON 文件
#     with open(json_file, 'r', encoding='utf-8') as file:
#         data = json.load(file)
    
#     # 遍历 JSON 数据
#     for item in data:
#         vulnerability = item.get("vulnerability")
#         check = item.get("check")
#         response = item.get("response")
        
#         # 判断response的开头是 "Answer: No" 还是 "Answer: Yes"
#         if response:
#             if response.startswith("Answer: No"):
#                 response_start = "Answer: No"
#             elif response.startswith("Answer: Yes"):
#                 response_start = "Answer: Yes"
#             else:
#                 continue  # 如果 response 不符合要求，跳过此条记录
        
#             # 统计 "vulnerability", "check" 和 "response_start" 组合
#             if vulnerability and check in ["TP", "FP"]:
#                 stats[vulnerability][(check, response_start)] += 1
    
#     # 打印统计结果
#     for vulnerability, counts in stats.items():
#         print(f'Vulnerability: {vulnerability}')
#         for (check, response_start), count in counts.items():
#             print(f'  Check: {check}, Response: {response_start}, Count: {count}')

# # 使用此函数来统计你需要的json文件
# json_file_path = "Openai_api_experiment/GPT_results/confuzzius/confuzzius_ver2.1.json"
# count_vulnerability_responses(json_file_path)
import json
from collections import defaultdict

def count_vulnerability_responses(json_file):
    # 初始化一个字典，用于存储每个 "vulnerability" 的 "check" 和 "response" 组合的计数
    stats = defaultdict(lambda: defaultdict(int))
    
    # 打开并读取 JSON 文件
    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # 遍历 JSON 数据
    for item in data:
        vulnerability = item.get("vulnerability")
        check = item.get("check")
        response = item.get("response")
        
        # 判断response的开头是 "Answer: No" 还是 "Answer: Yes"
        if response:
            if response.startswith("Answer: No"):
                response_start = "Answer: No"
            elif response.startswith("Answer: Yes"):
                response_start = "Answer: Yes"
            else:
                continue  # 如果 response 不符合要求，跳过此条记录
        
            # 统计 "vulnerability", "check" 和 "response_start" 组合
            if vulnerability and check in ["TP", "FP"]:
                stats[vulnerability][(check, response_start)] += 1
    
    # 打印统计结果，并将组合按要求标记
    for vulnerability, counts in stats.items():
        print(f'Vulnerability: {vulnerability}')
        for (check, response_start), count in counts.items():
            # 根据规则进行标记
            if check == "FP" and response_start == "Answer: No":
                label = "TP"
            elif check == "FP" and response_start == "Answer: Yes":
                label = "FN"
            elif check == "TP" and response_start == "Answer: No":
                label = "FP"
            elif check == "TP" and response_start == "Answer: Yes":
                label = "TN"
            
            # 打印标记和数量
            # print(f'  {label}: Check: {check}, Response: {response_start}, Count: {count}')
            print(f'  {label}:  Count: {count}')

# 使用此函数来统计你需要的json文件
json_file_path = "Openai_api_experiment/GPT_results/mythril/mythril_ver2.1_O1.json"
count_vulnerability_responses(json_file_path)
