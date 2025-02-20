import os
import json

def find_sol_files(directory, output_file):
    """
    查找指定目录下的所有 .sol 文件并将路径写入到一个 JSON 文件中。

    :param directory: 需要搜索的目录路径
    :param output_file: 保存结果的 JSON 文件路径
    """
    sol_files = []

    # 遍历目录及其子目录
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.sol'):
                # 获取 .sol 文件的完整路径
                full_path = os.path.join(root, file)
                sol_files.append(full_path)

    # 将路径列表写入 JSON 文件
    with open(output_file, 'w', encoding='utf-8') as json_file:
        json.dump(sol_files, json_file, indent=4, ensure_ascii=False)

    print(f"找到 {len(sol_files)} 个 .sol 文件，路径已保存到 {output_file}")

# 使用示例
if __name__ == "__main__":
    directory_to_search = input("请输入要搜索的目录路径：").strip()
    output_json_file = input("请输入输出 JSON 文件的路径：").strip()
    
    find_sol_files(directory_to_search, output_json_file)
