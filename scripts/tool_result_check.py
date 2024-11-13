import os
import json

def load_json(file_path):
    """加载 JSON 文件"""
    with open(file_path, 'r') as f:
        return json.load(f)

# def extract_smartbugs_path(file_path):
#     """从 smartbugs.json 中提取文件路径的 DAppSCAN-source 部分"""
#     return file_path.split('DAppSCAN-source', 1)[-1]

def extract_smartbugs_path(file_path):
    """从 smartbugs.json 中提取文件路径的 DAppSCAN-source 部分，保留 DAppSCAN-source"""
    split_str = 'DAppSCAN-source'
    idx = file_path.find(split_str)
    if idx != -1:
        return file_path[idx:]  # 从'DAppSCAN-source'开始截取路径
    return file_path  # 如果找不到'DAppSCAN-source'，返回原始路径


def map_category_to_vulname(categories, mapping_rules):
    """根据 mapping_rules.json 将 category 映射到 vulname"""
    return [mapping_rules.get(category, None) for category in categories if mapping_rules.get(category, None) is not None]

# def map_category_to_vulname(categories, mapping_rules):
#     """根据 mapping_rules.json 将 category 映射到 vulname，确保返回一个展平的列表"""
#     mapped_vulnames = []
#     for category in categories:
#         vulnames = mapping_rules.get(category)
#         if vulnames:
#             if isinstance(vulnames, list):
#                 mapped_vulnames.extend(vulnames)  # 如果是列表，使用 extend
#             else:
#                 mapped_vulnames.append(vulnames)  # 如果是字符串，使用 append
#     return mapped_vulnames


# def compare_vulnames(vul_name, category_mapping, filename, category, vul_info_collector):
#     """根据 vul_name 和 category_mapping 比较生成 TP, FP, FN, TN，同时收集 FP 和 TP 信息"""
#     tp, fp, fn, tn = 0, 0, 0, 0

#     # 情况 1: category_mapping 为空
#     if not category_mapping:
#         if not vul_name:  # 两者均为空，记作 TN
#             tn += 1
#         else:  # vul_name 不为空，记作 FP
#             for vn in vul_name:
#                 fp += 1
#                 vul_info_collector['FP'].append({
#                     "filename": filename,
#                     "category": category,
#                     "category_mapping": category_mapping,
#                     "vulname": vn
#                 })

#     # 情况 2: category_mapping 不为空
#     else:
#         if not vul_name:  # vul_name 为空，category_mapping 不为空，记作 FN
#             fn += len(category_mapping)
#         else:
#             # 进行数组比较
#             # 我们创建副本以便逐步从中移除匹配的元素
#             vulname_copy = vul_name.copy()
#             category_mapping_copy = category_mapping.copy()

#             # 用于统计匹配的元素
#             tp = 0

#             # 找出匹配的元素，将其计作 TP
#             for category in category_mapping:
#                 if category in vulname_copy:
#                     tp += 1
#                     vul_info_collector['TP'].append({
#                         "filename": filename,
#                         "category": category,
#                         "category_mapping": category_mapping,
#                         "vulname": category
#                     })
#                     # 从副本中移除匹配的元素
#                     vulname_copy.remove(category)

#             # 处理剩余的 vulname 元素，未匹配的部分计作 FP
#             for vn in vulname_copy:
#                 fp += 1
#                 vul_info_collector['FP'].append({
#                     "filename": filename,
#                     "category": category,
#                     "category_mapping": category_mapping,
#                     "vulname": vn
#                 })

#             # 处理剩余的 category_mapping 元素，未匹配的部分计作 FN
#             unmatched_category_mapping = [cat for cat in category_mapping if cat not in vulname_copy]
#             fn += len(unmatched_category_mapping)

#     return tp, fp, fn, tn

# def compare_vulnames(vul_name, category_mapping, filename, category, vul_info_collector):
#     """根据 vul_name 和 category_mapping 比较生成 TP, FP, FN, TN，同时收集 FP 和 TP 信息"""
#     tp, fp, fn, tn = 0, 0, 0, 0

#     # 将列表转换为集合
#     vul_name_set = set(vul_name) if vul_name else set()
#     category_mapping_set = set(category_mapping) if category_mapping else set()

#     # 如果 category_mapping 为空
#     if not category_mapping_set:
#         if not vul_name_set:
#             tn += 1  # 两者均为空，记作 TN
#         else:
#             fp += len(vul_name_set)  # vul_name 不为空，记作 FP
#             for vn in vul_name_set:
#                 vul_info_collector['FP'].append({
#                     "filename": filename,
#                     "category": category,
#                     "category_mapping": category_mapping,
#                     "vulname": vn
#                 })
#     else:
#         if not vul_name_set:
#             fn += len(category_mapping_set)  # vul_name 为空，category_mapping 不为空，记作 FN
#         else:
#             # 计算 TP（正确识别的漏洞）
#             tp_set = vul_name_set & category_mapping_set
#             tp += len(tp_set)
#             for vn in tp_set:
#                 vul_info_collector['TP'].append({
#                     "filename": filename,
#                     "category": category,
#                     "category_mapping": category_mapping,
#                     "vulname": vn
#                 })

#             # 计算 FP（错误报告的漏洞）
#             fp_set = vul_name_set - category_mapping_set
#             fp += len(fp_set)
#             for vn in fp_set:
#                 vul_info_collector['FP'].append({
#                     "filename": filename,
#                     "category": category,
#                     "category_mapping": category_mapping,
#                     "vulname": vn
#                 })

#             # 计算 FN（遗漏的漏洞）
#             fn_set = category_mapping_set - vul_name_set
#             fn += len(fn_set)

#     return tp, fp, fn, tn

def compare_vulnames(vul_name, category_mapping, filename, category, vul_info_collector):
    """根据 vul_name 和 category_mapping 比较生成 TP, FP, FN, TN，同时收集 FP 和 TP 信息"""
    tp, fp, fn, tn = 0, 0, 0, 0

    # 情况 1: category_mapping 为空
    if not category_mapping:
        if not vul_name:  # 两者均为空，记作 TN
            tn += 1
        else:  # vul_name 不为空，记作 FP
            for vn in vul_name:
                fp += 1
                vul_info_collector['FP'].append({
                    "filename": filename,
                    "category": category,
                    "category_mapping": category_mapping,
                    "vulname": vn
                })

    # 情况 2: category_mapping 不为空
    else:
        if not vul_name:  # vul_name 为空，category_mapping 不为空，记作 FN
            fn += len(category_mapping)
        else:
            # 处理数组比较的逻辑
            vulname_copy = vul_name.copy()

            # 找出匹配的元素，将其计作 TP
            for category_item in category_mapping:
                if isinstance(category_item, list):  # 如果 category_mapping 是数组
                    match_found = False
                    for item in category_item:  # 遍历数组中的每个字符串
                        if item in vulname_copy:
                            tp += 1
                            vul_info_collector['TP'].append({
                                "filename": filename,
                                "category": category,
                                "category_mapping": category_item,
                                "vulname": item
                            })
                            vulname_copy.remove(item)
                            match_found = True
                            break  # 如果有一个匹配，立即跳出循环

                    if not match_found:  # 如果数组中的所有项都不匹配
                        fp += 1
                        vul_info_collector['FP'].append({
                            "filename": filename,
                            "category": category,
                            "category_mapping": category_item,
                            "vulname": None
                        })
                else:  # category_mapping 是单个字符串
                    if category_item in vulname_copy:
                        tp += 1
                        vul_info_collector['TP'].append({
                            "filename": filename,
                            "category": category,
                            "category_mapping": category_item,
                            "vulname": category_item
                        })
                        vulname_copy.remove(category_item)
                    else:
                        fn += 1  # 如果没有找到匹配项，计作 FN

            # 处理剩余的 vulname 元素，未匹配的部分计作 FP
            for vn in vulname_copy:
                fp += 1
                vul_info_collector['FP'].append({
                    "filename": filename,
                    "category": category,
                    "category_mapping": category_mapping,
                    "vulname": vn
                })

    return tp, fp, fn, tn




def process_result_and_mapping(result_file, smartbugs_file, vul_info, mapping_rules, vul_info_collector):
    """处理每个 result.json 和 smartbugs.json 文件"""
    # 加载 result.json
    result_data = load_json(result_file)
    vul_name = [finding['name'] for finding in result_data.get('findings', [])]

    # 加载 smartbugs.json 中的样本路径
    smartbugs_data = load_json(smartbugs_file)
    smartbugs_path = extract_smartbugs_path(smartbugs_data['filename'])

    # 在 vul_info.json 中查找对应的标签（若找不到则为阴性样本）
    sample_info = vul_info.get(smartbugs_path, {})
    categories = [swc['category'] for swc in sample_info.get('SWCs', [])]

    # 将 category 映射到 vulname
    category_mapping = map_category_to_vulname(categories, mapping_rules)

    # 比较 vul_name 和 category_mapping，获取 TP, FP, FN, TN
    return compare_vulnames(vul_name, category_mapping, smartbugs_path, categories, vul_info_collector)

def process_directory(input_dir, vul_info_path, mapping_rules_path, output_file):
    """递归遍历目录，处理所有 result.json 和 smartbugs.json 文件"""
    vul_info = load_json(vul_info_path)
    mapping_rules = load_json(mapping_rules_path)

    # 保存 FP 和 TP 的详细信息
    vul_info_collector = {
        'FP': [],
        'TP': []
    }

    total_tp, total_fp, total_fn, total_tn = 0, 0, 0, 0

    for root, _, files in os.walk(input_dir):
        if 'result.json' in files and 'smartbugs.json' in files:
            result_file = os.path.join(root, 'result.json')
            smartbugs_file = os.path.join(root, 'smartbugs.json')

            tp, fp, fn, tn = process_result_and_mapping(result_file, smartbugs_file, vul_info, mapping_rules, vul_info_collector)
            
            total_tp += tp
            total_fp += fp
            total_fn += fn
            total_tn += tn

    # # 输出 FP 和 TP 信息到指定的 JSON 文件
    # with open(output_file, 'w') as f:
    #     json.dump(vul_info_collector, f, indent=4)

    print(f"Total TP: {total_tp}, Total FP: {total_fp}, Total FN: {total_fn}, Total TN: {total_tn}")
    print(f"FP and TP details have been saved to {output_file}")
    return total_tp, total_fp, total_fn, total_tn

# 执行函数
input_directory = "Dapp_ToolResult/semgrep"  # 样本目录
vul_info_file = "vul_info/filtered_vul_exist_info.json"  # 样本标签文件
mapping_rules_file = "vulname_mapping/semgrep.json"  # 映射规则文件
output_json_file = "scripts/tool_result_check/semgrep/semgrep.json"  # 输出文件

process_directory(input_directory, vul_info_file, mapping_rules_file, output_json_file)
