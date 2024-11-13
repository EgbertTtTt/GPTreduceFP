"""
该脚本的主要功能是从指定目录中查找所有名为 'result.json' 的文件，分析它们的内容，判断是否为正常检测结果，并将结果进行分类汇总。对于检测不正常的文件，会将其所在的文件夹移动到指定的错误结果文件夹中，最后生成一个包含分析结果的汇总文件。

主要功能模块:
1. `move_folder_to_new_base`: 将包含特定文件的文件夹移动到新的目标文件夹中。
2. `analyze_result_file`: 解析并分析 'result.json' 文件，判断检测是否正常。
3. `find_and_analyze_results`: 在指定目录中查找 'result.json' 文件，并分析其结果，分类并处理检测结果。
4. `write_summary_to_json`: 将分析结果写入到 JSON 文件中。

函数说明:

1. move_folder_to_new_base(file_path, new_base_folder):
    将包含指定文件的文件夹移动到新的目标文件夹。
    
    参数:
    - file_path (str): 文件的绝对路径。
    - new_base_folder (str): 新的目标文件夹路径。

2. analyze_result_file(result_file_path):
    解析给定的 'result.json' 文件，判断是否为正常检测结果。
    
    参数:
    - result_file_path (str): result.json 文件的绝对路径。
    
    返回值:
    - bool: 如果为正常检测返回 True，异常检测返回 False。

3. find_and_analyze_results(directory):
    遍历指定目录，查找所有 'result.json' 文件，并分析其结果。
    
    参数:
    - directory (str): 需要搜索的根目录路径。
    
    返回值:
    - dict: 包含错误和正常检测结果的汇总信息，统计错误和正常的文件数。

4. write_summary_to_json(summary, output_file):
    将汇总信息写入到指定的 JSON 文件中。
    
    参数:
    - summary (dict): 汇总的结果字典。
    - output_file (str): 输出的 JSON 文件路径。

主程序:
1. 指定要分析的目录 `directory`。
2. 指定错误结果文件夹 `error_result_folder`。
3. 指定输出汇总文件路径 `output_json`。
4. 执行分析函数 `find_and_analyze_results` 获取结果。
5. 使用 `write_summary_to_json` 将汇总结果写入 JSON 文件。
"""


import os
import shutil
import json


def delete_empty_folders(directory):
    """
    递归删除指定目录下的所有空文件夹，从最底层开始逐层检查。
    
    :param directory: 需要检查的目录路径
    :return: 如果目录为空且已删除，返回True；否则返回False
    """
    # 如果不是一个目录，直接返回
    if not os.path.isdir(directory):
        return False
    
    # 获取目录下的所有内容
    items = os.listdir(directory)
    
    # 递归检查子文件夹
    for item in items:
        item_path = os.path.join(directory, item)
        if os.path.isdir(item_path):
            # 递归调用，删除子文件夹中的空文件夹
            delete_empty_folders(item_path)
    
    # 再次获取目录内容（因为子文件夹可能已经删除）
    if len(os.listdir(directory)) == 0:
        # 如果目录现在为空，删除它
        os.rmdir(directory)
        print(f"已删除空文件夹: {directory}")
        return True
    
    return False

def move_folder_to_new_base(file_path, new_base_folder):
    """
    将包含文件的整个文件夹移动到新的目标文件夹中，并删除原来的文件夹。
    如果目标文件夹中已经存在同名文件夹，则会为新文件夹添加数字后缀以避免冲突。
    
    :param file_path: 文件的绝对路径
    :param new_base_folder: 新的目标文件夹的路径
    """
    # 确保文件存在
    if not os.path.isfile(file_path):
        raise FileNotFoundError(f"文件 {file_path} 不存在")
    
    # 获取文件所在的文件夹路径
    folder_to_move = os.path.dirname(file_path)
    
    # 获取要移动的文件夹名称（保持原有的文件夹结构）
    folder_name = os.path.basename(folder_to_move)
    
    # 构造目标文件夹的初始路径
    new_folder_path = os.path.join(new_base_folder, folder_name)
    
    # 如果目标路径已存在相同名称的文件夹，添加后缀以避免重名
    counter = 1
    unique_folder_path = new_folder_path
    while os.path.exists(unique_folder_path):
        unique_folder_path = f"{new_folder_path}_{counter}"
        counter += 1
    
    # 确保目标文件夹的父目录存在
    os.makedirs(new_base_folder, exist_ok=True)
    
    # 将整个文件夹移动到新的位置
    shutil.move(folder_to_move, unique_folder_path)
    
    # 打印提示信息
    print(f"文件夹 {folder_to_move} 已移动到 {unique_folder_path}")

# 示例使用
# move_folder_to_new_base("/path/to/your/file.txt", "/path/to/new/folder")

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

def find_and_analyze_results(directory):
    """
    在指定的目录中找到所有名为'result.json'的文件，并调用analyze_result_file进行分析。
    
    :param directory: 要搜索的文件目录
    """
    # 使用os.walk遍历目录
    
    summary = {
        "errors": [],
        "normal": [],
        "count_errors": 0,
        "count_normal": 0
    }

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file == 'result.json':
                result_file_path = os.path.join(root, file)
                is_normal=analyze_result_file(result_file_path)
                if is_normal:
                  summary["normal"].append(result_file_path)
                  summary["count_normal"] += 1
                  
                else:
                  summary["errors"].append(result_file_path)
                  summary["count_errors"] += 1
                  move_folder_to_new_base(result_file_path,error_result_folder)
                  
    return summary
# 示例使用
# find_and_analyze_results("/path/to/your/directory")

def write_summary_to_json(summary, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=4)

if __name__ == "__main__":
  directory = 'Dapp_ToolResult/confuzzius'
  error_result_folder = "error_result/confuzzius"
  output_json = "error_result/confuzzius/summary.json"
  results_summary = find_and_analyze_results(directory)
  write_summary_to_json(results_summary, output_json)
  delete_empty_folders(directory)