import json

# 读取JSON文件
with open('Openai_api_experiment/GPT_results/confuzzius/confuzzius_ver4.1.3.json', 'r') as file:
    data = json.load(file)

# 初始化计数器
fp_no_count = 0
tp_yes_count = 0
tp_no_count = 0
fp_yes_count = 0

# 统计数据
for item in data:
    check = item.get("check")
    response = item.get("response")
    
    if check == "FP" and response == "Answer: No":
        fp_no_count += 1
    elif check == "TP" and response == "Answer: Yes":
        tp_yes_count += 1
    elif check == "TP" and response == "Answer: No":
        tp_no_count += 1
    elif check == "FP" and response == "Answer: Yes":
        fp_yes_count += 1

# 打印结果
print(f'“check”为“FP”， "response"为"Answer: No" FP reduce的数量: {fp_no_count}')
print(f'“check”为“TP”， "response"为"Answer: Yes" TP after的数量: {tp_yes_count}')
print(f'“check”为“TP”， "response"为"Answer: No" 的数量: {tp_no_count}')
print(f'“check”为“FP”， "response"为"Answer: Yes" 的数量: {fp_yes_count}')
