import json
import random

def filter_and_sample_fp_items(input_file, output_file, sample_size):
    # 读取 JSON 文件
    with open(input_file, 'r', encoding='utf-8') as file:
        data = json.load(file)

    # 过滤出 "check" 为 "FP" 的项
    fp_items = [item for item in data if item.get("check") == "TP"]

    # 随机抽取指定数量的项，如果指定数量超过总数，则选择全部
    sampled_items = random.sample(fp_items, min(sample_size, len(fp_items)))

    # 将抽取的项保存到新的 JSON 文件
    with open(output_file, 'w', encoding='utf-8') as outfile:
        json.dump(sampled_items, outfile, indent=4, ensure_ascii=False)

    print(f"{len(sampled_items)} 条数据已保存到 {output_file}")

# 示例用法
input_file = 'scripts/tool_result_check/solhint/vulcode.json'  # 输入 JSON 文件路径
output_file = 'scripts/tool_result_check/solhint/random_vulcode_TP.json'  # 输出 JSON 文件路径
sample_size = 14  # 你想抽取的项的数量

filter_and_sample_fp_items(input_file, output_file, sample_size)
