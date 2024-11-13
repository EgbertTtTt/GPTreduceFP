import os

def count_sol_files_and_avg_lines(directory):
    # 初始化统计变量
    sol_count = 0
    total_lines = 0

    # 遍历目录
    for root, dirs, files in os.walk(directory):
        for file in files:
            # 检查文件扩展名是否为.sol
            if file.endswith('.sol'):
                sol_count += 1
                file_path = os.path.join(root, file)
                
                # 计算文件的行数
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    total_lines += len(lines)

    # 计算平均代码行数
    avg_lines = total_lines / sol_count if sol_count > 0 else 0

    # 返回统计结果
    return sol_count, avg_lines

# 使用示例
directory = "Dapp_dataset"
sol_count, avg_lines = count_sol_files_and_avg_lines(directory)
print(f"在 '{directory}' 目录下找到 {sol_count} 个 .sol 文件，平均代码行数为 {avg_lines:.2f} 行。")
