import json
from collections import defaultdict

def count_vulnerability_responses(json_file):
    # 初始化一个字典，用于存储每个 "vulnerability" 的 "check" 和 "response" 组合的计数
    stats = defaultdict(lambda: defaultdict(int))
    # 初始化一个字典，用于存储每个 vulnerability 下每个标记的 code_segment 长度
    code_length_stats = defaultdict(lambda: defaultdict(list))
    
    # 打开并读取 JSON 文件
    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # 遍历 JSON 数据
    for item in data:
        vulnerability = item.get("vulnerability")
        check = item.get("check")
        response = item.get("response")
        code_segment = item.get("code_segment", "")
        
        # 判断 response 的开头是 "Answer: No" 还是 "Answer: Yes"
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
                
                # 根据规则进行标记
                if check == "FP" and response_start == "Answer: No":
                    label = "TP"
                elif check == "FP" and response_start == "Answer: Yes":
                    label = "FN"
                elif check == "TP" and response_start == "Answer: No":
                    label = "FP"
                elif check == "TP" and response_start == "Answer: Yes":
                    label = "TN"
                
                # 记录 code_segment 的长度到对应的 vulnerability 和 label
                code_length_stats[vulnerability][label].append(len(code_segment))
    
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
            print(f'  {label}:  Count: {count}')
    
    # 计算并打印每个 vulnerability 下每个标记的 code_segment 平均长度
    print("\nAverage code_segment length per label and vulnerability:")
    for vulnerability, label_stats in code_length_stats.items():
        print(f'Vulnerability: {vulnerability}')
        for label, lengths in label_stats.items():
            if lengths:
                avg_length = sum(lengths) / len(lengths)
                print(f'  {label}: Average Length: {avg_length:.2f} characters')
            else:
                print(f'  {label}: No code segments available')

# 使用此函数来统计你需要的json文件
json_file_path = "Openai_api_experiment/GPT_results/sfuzz/sfuzz_ver2.1.json"
count_vulnerability_responses(json_file_path)
