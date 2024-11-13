"""_summary_
用于找出成功检测的问题夹并统计数量
Returns:
    _type_: _description_
"""

import os
import json

# 设置根文件夹路径
root_folder = "test/result/confuzzius/20240905_0905/dataset"
# 设置结果输出文件
output_file = "confuzzius_vul.txt"

# 初始化结果存储
tool_results = {}


def analyze_result_file(result_file_path):
    """解析 result.json 文件，判断是否为正常检测"""
    with open(result_file_path, "r", encoding='utf-8') as file:
        result_data = json.load(file)

        # 获取errors、fails和findings内容
        errors = result_data.get("errors", [])
        fails = result_data.get("fails", [])
        findings = result_data.get("findings", [])

        # 判断检测是否正常
        if (not errors and not fails and not findings) or findings:
            return True  # 正常检测
        return False  # 非正常检测


def analyze_folder(folder_path, tool_name):
    """分析指定文件夹中的 result.json 文件"""
    result_file_path = os.path.join(folder_path, "result.json")

    if os.path.exists(result_file_path):
        # 分析单个 result.json 文件
        is_normal = analyze_result_file(result_file_path)

        if tool_name not in tool_results:
            tool_results[tool_name] = {
                "正常检测": 0,
                "非正常检测": 0,
                "正常文件夹": [],
                "非正常文件夹": []
            }

        if is_normal:
            tool_results[tool_name]["正常检测"] += 1
            tool_results[tool_name]["正常文件夹"].append(folder_path)
        else:
            tool_results[tool_name]["非正常检测"] += 1
            tool_results[tool_name]["非正常文件夹"].append(folder_path)
    else:
        print(f"{folder_path} 中找不到 result.json 文件。")


def save_results_to_txt(file_path, tool_results):
    """将分析结果保存到 txt 文件"""
    with open(file_path, "w", encoding="utf-8") as f:
        for tool_name, results in tool_results.items():
            f.write(f"工具：{tool_name}\n")
            f.write(f"正常检测的文件夹数量: {results['正常检测']}\n")
            f.write(f"非正常检测的文件夹数量: {results['非正常检测']}\n")
            f.write("\n正常检测的文件夹:\n")
            for folder in results["正常文件夹"]:
                f.write(f"{folder}\n")
            f.write("\n非正常检测的文件夹:\n")
            for folder in results["非正常文件夹"]:
                f.write(f"{folder}\n")
            f.write("\n" + "=" * 50 + "\n")


# 遍历根目录，查找各个检测工具的结果
for root, dirs, files in os.walk(root_folder):
    for dir_name in dirs:
        folder_path = os.path.join(root, dir_name)

        # 检测工具名是父目录名字的一部分，可以自行根据需要调整提取方式
        parent_folder = os.path.basename(os.path.dirname(os.path.dirname(folder_path)))

        # 以父文件夹名为工具名
        analyze_folder(folder_path, parent_folder)

# 将结果保存到txt文件
save_results_to_txt(output_file, tool_results)

print(f"分析结果已保存至 {output_file}")
