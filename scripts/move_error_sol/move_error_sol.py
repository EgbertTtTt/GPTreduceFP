##
#脚本作用：用于根据solc报错将数据集中有问题的样本移出，转移到对应的文件夹中
##
import os
import shutil

def move_files_from_txt(txt_path, destination_folder):
    # 确保目标文件夹存在
    os.makedirs(destination_folder, exist_ok=True)
    
    # 打开并读取txt文件
    with open(txt_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    # 逐行处理
    for line in lines:
        file_path = line.strip()
        if os.path.isfile(file_path):
            # 获取文件名
            file_name = os.path.basename(file_path)
            # 构建新的文件路径
            new_path = os.path.join(destination_folder, file_name)
            # 移动文件
            shutil.move(file_path, new_path)
            print(f"Moved: {file_path} to {new_path}")
        else:
            print(f"File not found: {file_path}")

if __name__ == "__main__":
    txt_file_path = 'smartbugs/error_flatten_file_no_solc.txt'  # 替换为你的txt文件路径
    destination_folder = 'smartbugs/error_flatten_file_no_solc/Final'  # 替换为你的目标文件夹路径
    move_files_from_txt(txt_file_path, destination_folder)
