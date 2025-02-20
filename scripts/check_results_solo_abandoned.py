import json
"""
_summary_:单个result.json文件的数据统计
"""

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

# def extract_vulnerabilities_by_filename(target_filename, file_path):
#     """
#     从 JSON 文件中提取所有 "filename" 为指定字符串的项的 "vulnerability" 值。

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

#     vulnerabilities = [item.get("vulnerability", "") for item in data if item.get("filename") == target_filename]
    
#     return vulnerabilities
  
  
def extract_vulnerabilities_by_filename(target_filename, file_path):
    """
    从 JSON 文件中提取所有 "filename" 为指定字符串的项的 "vulnerability" 值，
    且 "response" 字段不包含 "Answer: No"。

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

    vulnerabilities = [
        item.get("vulnerability", "") for item in data
        if item.get("filename") == target_filename and "Answer: No" not in item.get("response", "")
    ]
    
    return vulnerabilities

def map_vulnerabilities_to_categories(vulnerabilities, mapping_file_path):
    """
    将漏洞列表中的每个字符串，根据映射 JSON 文件提供的关系进行转化。

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

    mapped_vulnerabilities = []
    for vulnerability in vulnerabilities:
        mapped_value = [key for key, value in mapping_data.items() if value == vulnerability]
        if mapped_value:
            mapped_vulnerabilities.append(", ".join(mapped_value))

    return mapped_vulnerabilities

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
    output_file = 'test/confuzzius/confuzzius_result_ver3.1.json'
    
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
            
    #-----------------------------读取result文件，提取filename---------------------------------------

    result_file = 'GPT_results/confuzzius/confuzzius_ver2.1.json'
    mapping_file = 'vulname_mapping/confuzzius.json'
    swc_file = 'vul_info/filtered_vul_exist_info.json'


    filenames, filename_count = extract_filenames_and_count(result_file)


    for filename in filenames:
      #从每个文件提取漏洞信息
      vulnerabilities = extract_vulnerabilities_by_filename(filename, result_file)
      if not vulnerabilities:
        print(f"警告：文件 {filename} 中没有找到漏洞信息。")
        continue
      
      #使用映射文件将漏洞转化为swc分类
      mapped_vulnerabilities = map_vulnerabilities_to_categories(vulnerabilities, mapping_file)
      
      #处理filename的头
      filename_swc = remove_prefix_from_path(filename)
      
      #提取数据集对应样本的标签
      swcs = extract_swcs_from_filename(filename_swc, swc_file)
      if not swcs:
        print(f"警告：文件 {filename_swc} 中没有找到相关的 SWC 类别。")
        continue 

      #比对并处理结果
      match_lists(swcs, mapped_vulnerabilities, output_file)
  


# --------------------调用主函数---------------------
if __name__ == '__main__':
    main()
