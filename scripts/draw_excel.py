# import os
# import json
# import pandas as pd

# def json_to_excel(json_dir, output_excel):
#     # 创建一个空的DataFrame用于存储所有的数据
#     all_data = pd.DataFrame()

#     # 遍历json_dir中的每个子目录
#     for tool_name in os.listdir(json_dir):
#         tool_path = os.path.join(json_dir, tool_name)
#         json_file = os.path.join(tool_path, f"{tool_name}.json")
        
#         # 检查是否是目录且包含目标json文件
#         if os.path.isdir(tool_path) and os.path.isfile(json_file):
#             # 打开并加载json文件
#             with open(json_file, 'r') as f:
#                 data = json.load(f)
                
#                 # 创建一个新的DataFrame来存储每个工具的数据
#                 tool_data = []
                
#                 # 遍历每个SWC漏洞项
#                 for swc, values in data.items():
#                     # 获取TP, FP, TN, FN的值，使用'\\'代替None或null值
#                     tp = values['TP'] if values['TP'] is not None else '\\'
#                     fp = values['FP'] if values['FP'] is not None else '\\'
#                     tn = values['TN'] if values['TN'] is not None else '\\'
#                     fn = values['FN'] if values['FN'] is not None else '\\'
                    
#                     # 将数据添加到tool_data列表
#                     tool_data.append([swc, tp, fp, tn, fn])
                
#                 # 将该工具的数据转换为DataFrame
#                 tool_df = pd.DataFrame(tool_data, columns=['Vulnerability', f'{tool_name}_TP', f'{tool_name}_FP', f'{tool_name}_TN', f'{tool_name}_FN'])
#                 tool_df.set_index('Vulnerability', inplace=True)
                
#                 # 将该工具的DataFrame添加到all_data中
#                 # 使用合并方式，将不同工具的数据并列显示
#                 if all_data.empty:
#                     all_data = tool_df
#                 else:
#                     all_data = all_data.join(tool_df, how='outer')

#     # 使用'\\'替换NaN值
#     all_data.fillna('\\', inplace=True)
    
#     # 保存所有数据到Excel
#     all_data.to_excel(output_excel, engine='openpyxl')

# # 指定json文件夹路径和输出的Excel文件路径
# json_dir = 'check_results_RQ1'  # 请修改为你自己的json文件夹路径
# output_excel = 'RQ1.xlsx'    # 输出的Excel文件名

# # 执行函数
# json_to_excel(json_dir, output_excel)

# print(f'Excel文件已保存为 {output_excel}')
import os
import json
import pandas as pd

def json_to_excel(json_dir, output_excel):
    # 创建一个空的DataFrame用于存储所有的数据
    all_data = pd.DataFrame()

    # 获取所有工具子目录，并按字母顺序排序
    tools = sorted([tool_name for tool_name in os.listdir(json_dir) if os.path.isdir(os.path.join(json_dir, tool_name))])

    # 遍历排序后的工具子目录
    for tool_name in tools:
        tool_path = os.path.join(json_dir, tool_name)
        json_file = os.path.join(tool_path, f"{tool_name}.json")
        
        # 检查是否存在目标json文件
        if os.path.isfile(json_file):
            # 打开并加载json文件
            with open(json_file, 'r') as f:
                data = json.load(f)
                
                # 创建一个新的DataFrame来存储每个工具的数据
                tool_data = []
                
                # 遍历每个SWC漏洞项
                for swc, values in data.items():
                    # 获取TP, FP, TN, FN的值，使用'\\'代替None或null值
                    tp = values['TP'] if values['TP'] is not None else '\\'
                    fp = values['FP'] if values['FP'] is not None else '\\'
                    tn = values['TN'] if values['TN'] is not None else '\\'
                    fn = values['FN'] if values['FN'] is not None else '\\'
                    
                    # 将数据添加到tool_data列表
                    tool_data.append([swc, tp, fp, tn, fn])
                
                # 将该工具的数据转换为DataFrame
                tool_df = pd.DataFrame(tool_data, columns=['Vulnerability', f'{tool_name}_TP', f'{tool_name}_FP', f'{tool_name}_TN', f'{tool_name}_FN'])
                tool_df.set_index('Vulnerability', inplace=True)
                
                # 将该工具的DataFrame添加到all_data中
                # 使用合并方式，将不同工具的数据并列显示
                if all_data.empty:
                    all_data = tool_df
                else:
                    all_data = all_data.join(tool_df, how='outer')

    # 使用'\\'替换NaN值
    all_data.fillna('\\', inplace=True)
    
    # 保存所有数据到Excel
    all_data.to_excel(output_excel, engine='openpyxl')

# 指定json文件夹路径和输出的Excel文件路径
json_dir = 'check_results_RQ1'  # 请修改为你自己的json文件夹路径
output_excel = 'RQ1.xlsx'    # 输出的Excel文件名

# 执行函数
json_to_excel(json_dir, output_excel)

print(f'Excel文件已保存为 {output_excel}')
