import json

def extract_keys_and_create_new_json(input_json):
    """
    提取输入 JSON 数据的所有键，并为每个键创建一个新的结构，
    结构包含 "TP", "FP", "TN", "FN" 四个键，每个键的值初始化为 None。

    参数:
        input_json (dict): 输入的 JSON 数据，通常是一个字典结构。

    返回:
        dict: 新创建的字典，每个键都包含 "TP", "FP", "TN", "FN" 字段。
    """
    new_json = {}  # 初始化一个空字典，用来存放新的 JSON 结构

    # 遍历原始 JSON 数据中的每个键
    for key in input_json:
        # 为每个键创建一个包含 "TP", "FP", "TN", "FN" 字段的字典
        new_json[key] = {
            "TP": None,  # 初始值设置为 None，后续可以根据需要调整
            "FP": None,
            "TN": None,
            "FN": None
        }

    # 返回新创建的 JSON 结构
    return new_json

def main():
    
    #--------------------------------生成原始结果记录json目录-------------------------------------
    """
    主函数，负责从指定的输入文件读取 JSON 数据，提取键并生成新的结构，
    最终将结果写入输出文件。

    程序的执行流程如下：
    1. 读取输入文件。
    2. 提取 JSON 数据中的所有键，并为每个键创建一个新的字典结构。
    3. 将结果保存到输出文件。
    """
    # 输入 JSON 文件的路径
    input_file = 'vul_info/filtered_categorized_vul_info.json'
    
    # 输出 JSON 文件的路径
    output_file = 'result_template/result_template.json'
    
    # 尝试读取输入文件中的 JSON 数据
    try:
        with open(input_file, 'r', encoding='utf-8') as infile:
            input_data = json.load(infile)  # 将文件内容加载为 Python 字典
    except FileNotFoundError:
        print(f"Error: The file {input_file} was not found.")  # 文件未找到时的错误提示
        return
    except json.JSONDecodeError:
        print("Error: Failed to decode JSON from the input file.")  # JSON 解码失败时的错误提示
        return

    # 调用函数提取 JSON 数据中的键，并生成新的结构
    new_json = extract_keys_and_create_new_json(input_data)

    # 尝试将生成的结果写入输出文件
    try:
        with open(output_file, 'w', encoding='utf-8') as outfile:
            json.dump(new_json, outfile, ensure_ascii=False, indent=4)  # 格式化输出，确保中文正常显示
        print(f"New JSON has been saved to {output_file}")  # 输出文件保存成功的提示
    except Exception as e:
        print(f"Error: Failed to write to {output_file}. {e}")  # 处理写入文件时的错误
        
        
if __name__ == "__main__":
    main()