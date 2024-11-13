import os

def count_sol_files(directory):
    sol_file_count = 0
    
    # 使用 os.walk 递归遍历目录及其子目录
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".json"):
                sol_file_count += 1
    
    return sol_file_count

if __name__ == "__main__":
    # 需要统计的文件夹路径
    directory = 'Dapp_ToolResult/confuzzius'  # 将 'your_directory_path' 替换为你要统计的文件夹路径
    
    sol_files = count_sol_files(directory)
    print(f"Total number of .sol files: {sol_files}")
