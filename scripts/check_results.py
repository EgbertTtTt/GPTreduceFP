import json
import os
import glob

def read_json_file(file_path):
    """
    读取 JSON 文件并返回其内容。

    参数：
        file_path (str): JSON 文件路径。

    返回：
        dict or list: 解析后的 JSON 数据。
        None: 如果文件无法读取或格式错误。
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            data = json.load(file)
        return data
    except FileNotFoundError:
        print(f"文件未找到: {file_path}")
        return None
    except json.JSONDecodeError:
        print(f"JSON 文件格式错误: {file_path}")
        return None

def extract_filenames_and_count(file_path):
    """
    提取 JSON 文件中所有 "filename" 的值及其出现的数量，合并重复值。

    参数：
        file_path (str): JSON 文件路径。

    返回：
        tuple: (list, int) 包含去重后的 "filename" 的列表和总数量。
    """
    data = read_json_file(file_path)
    if not isinstance(data, list):
        print("JSON 数据格式错误，期望为列表。")
        return [], 0

    filenames = list({item.get("filename", "") for item in data if "filename" in item})
    count = len(filenames)

    return filenames, count

def extract_vulnerabilities_by_filename(target_filename, file_path):
    """
    从 JSON 文件中提取所有 "filename" 为指定字符串的项的 "vulnerability" 值。

    参数：
        target_filename (str): 要匹配的 "filename"。
        file_path (str): JSON 文件路径。

    返回：
        list: 包含所有匹配项的 "vulnerability" 值的列表。
    """
    data = read_json_file(file_path)
    if not isinstance(data, list):
        print("JSON 数据格式错误，期望为列表。")
        return []

    vulnerabilities = [item.get("vulnerability", "") for item in data if item.get("filename") == target_filename]
    
    return vulnerabilities
  
  
# def extract_vulnerabilities_by_filename(target_filename, file_path):
#     """
#     从 JSON 文件中提取所有 "filename" 为指定字符串的项的 "vulnerability" 值，
#     且 "response" 字段不包含 "Answer: No"。

#     参数：
#         target_filename (str): 要匹配的 "filename"。
#         file_path (str): JSON 文件路径。

#     返回：
#         list: 包含所有匹配项的 "vulnerability" 值的列表。
#     """
#     data = read_json_file(file_path)
#     if not isinstance(data, list):
#         print("JSON 数据格式错误，期望为列表。")
#         return []

#     vulnerabilities = [
#         item.get("vulnerability", "") for item in data
#         if item.get("filename") == target_filename and "Answer: No" not in item.get("response", "")
#     ]
    
#     return vulnerabilities

def map_vulnerabilities_to_categories(vulnerabilities, mapping_file_path):
    """
    将漏洞列表中的每个字符串，根据映射 JSON 文件提供的关系进行转化。
    解决了mapping中一个swc对应多个vulname导致的映射失败

    参数：
        vulnerabilities (list): 提取的漏洞字符串列表。
        mapping_file_path (str): 映射 JSON 文件路径。

    返回：
        list: 根据映射关系转化后的漏洞列表。
    """
    mapping_data = read_json_file(mapping_file_path)
    if not isinstance(mapping_data, dict):
        print("映射 JSON 数据格式错误，期望为字典。")
        return []

    # 构建反向映射表
    reverse_mapping = {}
    for key, values in mapping_data.items():
        if isinstance(values, list):
            for value in values:
                reverse_mapping[value] = key
        elif values is not None:
            reverse_mapping[values] = key

    # 映射漏洞
    mapped_vulnerabilities = []
    for vulnerability in vulnerabilities:
        if vulnerability in reverse_mapping:
            mapped_vulnerabilities.append(reverse_mapping[vulnerability])

    return mapped_vulnerabilities

# 辅助函数：读取 JSON 文件
def read_json_file(file_path):
    import json
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return json.load(file)
    except Exception as e:
        print(f"无法读取 JSON 文件：{e}")
        return None



# def map_vulnerabilities_to_categories(vulnerabilities, mapping_file_path):
#     """
#     将漏洞列表中的每个字符串，根据映射 JSON 文件提供的关系进行转化。

#     参数：
#         vulnerabilities (list): 提取的漏洞字符串列表。
#         mapping_file_path (str): 映射 JSON 文件路径。

#     返回：
#         list: 根据映射关系转化后的漏洞列表。
#     """
#     mapping_data = read_json_file(mapping_file_path)
#     if not isinstance(mapping_data, dict):
#         print("映射 JSON 数据格式错误，期望为字典。")
#         return []

#     mapped_vulnerabilities = []
#     for vulnerability in vulnerabilities:
#         mapped_value = [key for key, value in mapping_data.items() if value == vulnerability]
#         if mapped_value:
#             mapped_vulnerabilities.append(", ".join(mapped_value))

#     return mapped_vulnerabilities

def remove_prefix_from_path(file_path):
    """
    删除字符串中以 "Dapp_dataset/positive/" 开头的部分。

    参数：
        file_path (str): 原始文件路径。

    返回：
        str: 删除前缀后的路径。
    """
    prefix = "Dapp_dataset/positive/"
    if file_path.startswith(prefix):
        return file_path[len(prefix):]
    return file_path

def extract_swcs_from_filename(target_filename, json_file_path):
    """
    从 JSON 文件中提取指定文件名的项，并返回与该文件相关的所有 SWC "category" 列表。

    参数：
        target_filename (str): 要匹配的文件名。
        json_file_path (str): JSON 文件路径。

    返回：
        list: 包含所有匹配项的 SWC "category" 列表。
    """
    data = read_json_file(json_file_path)
    if not isinstance(data, dict):
        print("JSON 数据格式错误，期望为字典。")
        return []

    # Remove prefix from the filename
    target_filename = remove_prefix_from_path(target_filename)
    swcs = []

    # Loop through the items in the JSON data to find matches
    for file, details in data.items():
        if remove_prefix_from_path(file) == target_filename:
            swcs.extend([swc.get("category", "") for swc in details.get("SWCs", [])])
    
    return swcs

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
  
def match_lists(swc1, swc2, json_file_path):
    tp = []  # 存储TP的元素
    fn = []  # 存储FN的元素
    fp = []  # 存储FP的元素
    
    # 复制swc2以便不修改原始数据
    swc2_copy = [elem for elem in swc2 if elem != "none"]  # 移除swc2中的"none"
    
    # 遍历swc1中的元素
    for elem1 in swc1[:]:
        matched = False  # 标记是否找到匹配项
        
        # 遍历swc2中的元素
        for elem2 in swc2_copy[:]:
            # 如果elem1部分匹配elem2，视为匹配成功
            if elem1 in elem2:
                tp.append(elem1)  # 记录TP
                swc1.remove(elem1)  # 删除swc1中的元素
                swc2_copy.remove(elem2)  # 删除swc2中的元素
                matched = True  # 标记已匹配
                break
        
        if not matched:
            fn.append(elem1)  # 如果未匹配成功，记录FN
            swc1.remove(elem1)  # 从swc1中删除该元素
    
    # 如果swc1为空，记录swc2中剩余的FP
    if not swc1:
        fp.extend(swc2_copy)  # 剩余的swc2中的元素是FP
    
    # return tp, fn, fp
    
  #------------------------------------------------------------------
  
      # 打开并读取json文件
    try:
        with open(json_file_path, 'r') as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"文件 {json_file_path} 未找到，创建一个新的文件。")
        data = {}

    # 确保json中的每个元素初始化了计数（即TP, FP, FN等）
    for element in set(tp + fn + fp):  # 遍历所有TP, FN, FP中的元素
        if element not in data:
            data[element] = {
                "TP": 0,
                "FP": 0,
                "TN": 0,
                "FN": 0
            }
    
    # 更新TP、FN、FP计数
    for item in tp:
        if item in data:
            data[item]["TP"] = (data[item].get("TP", 0) or 0) + 1

    for item in fn:
        if item in data:
            data[item]["FN"] = (data[item].get("FN", 0) or 0) + 1

    for item in fp:
        if item in data:
            data[item]["FP"] = (data[item].get("FP", 0) or 0) + 1
    
    # 处理未涉及到的键，将其"TN"加1
    involved_elements = set(tp + fn + fp)
    for element in data:
        if element not in involved_elements:
            data[element]["TN"] = (data[element].get("TN", 0) or 0) + 1
    
    # 将更新后的数据写回json文件
    with open(json_file_path, 'w') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

    print(f"结果已成功写入 {json_file_path}.")



def main():
    # 输入、输出的根目录
    input_root_dir = 'Dapp_ToolResult_Merge'  # 假设包含工具目录的根目录
    output_root_dir = 'check_results_RQ1'  # 输出的根目录
    mapping_root_dir = 'vulname_mapping'  # 映射文件根目录
    swc_file = 'vul_info/filtered_vul_exist_info.json'  # SWC 类别文件
    input_template_file = 'vul_info/filtered_categorized_vul_info.json'  # 模板 JSON 文件

    # 尝试读取模板文件中的 JSON 数据
    try:
        with open(input_template_file, 'r', encoding='utf-8') as infile:
            template_data = json.load(infile)  # 将模板文件内容加载为 Python 字典
    except FileNotFoundError:
        print(f"Error: The template file {input_template_file} was not found.")  # 文件未找到时的错误提示
        return
    except json.JSONDecodeError:
        print("Error: Failed to decode JSON from the template file.")  # JSON 解码失败时的错误提示
        return

    # 遍历工具目录
    for tool_dir in os.listdir(input_root_dir):
        tool_path = os.path.join(input_root_dir, tool_dir)
        if not os.path.isdir(tool_path):
            continue

        # 寻找映射文件
        mapping_file = os.path.join(mapping_root_dir, f'{tool_dir}.json')
        if not os.path.isfile(mapping_file):
            print(f"Warning: Mapping file for {tool_dir} not found, skipping this tool.")
            continue

        # 遍历工具目录下的所有结果文件
        result_files = glob.glob(os.path.join(tool_path, '*.json'))
        for result_file in result_files:
            try:
                # 处理单个结果文件
                process_result_file(result_file, mapping_file, swc_file, output_root_dir, template_data, input_root_dir)
            except Exception as e:
                print(f"Error processing {result_file}: {e}")


def process_result_file(result_file, mapping_file, swc_file, output_root_dir, template_data, input_root_dir):
    # 尝试读取输入文件中的 JSON 数据
    try:
        with open(result_file, 'r', encoding='utf-8') as infile:
            input_data = json.load(infile)  # 将文件内容加载为 Python 字典
    except FileNotFoundError:
        print(f"Error: The file {result_file} was not found.")  # 文件未找到时的错误提示
        return
    except json.JSONDecodeError:
        print("Error: Failed to decode JSON from the input file.")  # JSON 解码失败时的错误提示
        return

    # 使用模板数据作为基础，生成新的 JSON 数据
    # new_json = template_data.copy()
    extracted_data = extract_keys_and_create_new_json(template_data)
    # for key, value in extracted_data.items():
    #     if isinstance(key, (str, int, float, bool)):
    #         new_json[key] = value
    #     else:
    #         print(f"Warning: Skipping unhashable key: {key}")

    relative_path = os.path.relpath(result_file, start=input_root_dir)
    output_file = os.path.join(output_root_dir, relative_path)
    output_dir = os.path.dirname(output_file)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # 尝试将生成的结果写入输出文件
    try:
        with open(output_file, 'w', encoding='utf-8') as outfile:
            json.dump(extracted_data, outfile, ensure_ascii=False, indent=4)  # 格式化输出，确保中文正常显示
        print(f"New JSON has been saved to {output_file}")  # 输出文件保存成功的提示
    except Exception as e:
        print(f"Error: Failed to write to {output_file}. {e}")  # 处理写入文件时的错误

    # 读取结果文件并提取 filename
    filenames, filename_count = extract_filenames_and_count(result_file)

    for filename in filenames:
        # 从每个文件提取漏洞信息
        vulnerabilities = extract_vulnerabilities_by_filename(filename, result_file)
        if not vulnerabilities:
            print(f"Warning: No vulnerabilities found in file {filename}.")
            continue

        # 使用映射文件将漏洞转化为 SWC 分类
        mapped_vulnerabilities = map_vulnerabilities_to_categories(vulnerabilities, mapping_file)

        # 处理 filename 的前缀
        filename_swc = remove_prefix_from_path(filename)

        # 提取数据集对应样本的标签
        swcs = extract_swcs_from_filename(filename_swc, swc_file)
        if not swcs:
            print(f"Warning: No related SWC category found in file {filename_swc}.")
            continue

        # 比对并处理结果
        match_lists(swcs, mapped_vulnerabilities, output_file)


# 你的其他函数实现，例如 extract_keys_and_create_new_json、extract_filenames_and_count、
# extract_vulnerabilities_by_filename、map_vulnerabilities_to_categories、remove_prefix_from_path、
# extract_swcs_from_filename、match_lists 等函数的定义需要保留并作为主逻辑的一部分。

if __name__ == "__main__":
    main()
