"""用于从resultjson中统计汇报的漏洞名称，方便编写matching rules用于统计数据"""
import json
from collections import defaultdict

# 读取json文件
with open('test/vulcode.json', 'r') as file:
    data = json.load(file)

# 创建一个字典用于统计 "vulnerability" 的类型和对应的个数
vulnerability_count = defaultdict(int)

# 遍历每一个记录，并统计 "vulnerability" 的类型
for entry in data:
    vulnerability = entry.get("name", "Unknown")
    vulnerability_count[vulnerability] += 1

# 将统计结果写入到一个新的json文件中
with open('test/vulname.json', 'w') as output_file:
    json.dump(vulnerability_count, output_file, indent=4)

print("统计结果已保存到 vulnerability_count.json 文件中。")
