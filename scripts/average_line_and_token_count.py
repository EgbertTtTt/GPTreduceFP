import os
import json
import re

def calculate_average_code_stats_in_folder(folder_path):
    total_lines = 0
    total_tokens = 0
    total_segments = 0
    
    # 遍历文件夹下所有文件和子文件夹
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file == 'vulcode.json':
                file_path = os.path.join(root, file)
                
                # 打开并加载JSON文件
                with open(file_path, 'r') as json_file:
                    data = json.load(json_file)
                    
                    # 处理每个json对象
                    for item in data:
                        code_segment = item.get("code_segment", "")
                        
                        # 计算行数
                        line_count = code_segment.count('\n') + 1  # 加1以计算最后一行
                        total_lines += line_count
                        
                        # 计算token数
                        tokens = re.findall(r'\S+', code_segment)  # 按非空白字符分割
                        token_count = len(tokens)
                        total_tokens += token_count
                        
                        total_segments += 1
    
    # 计算平均值
    average_lines = total_lines / total_segments if total_segments > 0 else 0
    average_tokens = total_tokens / total_segments if total_segments > 0 else 0
    
    print(f"Total files processed: {total_segments}")
    print(f"Average line count: {average_lines:.2f}")
    print(f"Average token count: {average_tokens:.2f}")

# 调用函数，传入文件夹路径
calculate_average_code_stats_in_folder('scripts/tool_result_check')
