##
#脚本用途：由于smartbugs工具在跑到4800个样本时会出现报错，将源数据集分割为6份来跑
##
import os
import shutil
import math

def divide_into_parts(src_dir, num_parts=6):
    # 获取源目录下的所有项目文件夹
    project_folders = [f for f in os.listdir(src_dir) if os.path.isdir(os.path.join(src_dir, f))]
    
    # 计算每个部分的大小
    total_projects = len(project_folders)
    part_size = math.ceil(total_projects / num_parts)
    
    # 创建目标文件夹
    for i in range(1, num_parts + 1):
        part_dir = os.path.join(src_dir, f'part{i}')
        if not os.path.exists(part_dir):
            os.makedirs(part_dir)
    
    # 分配项目文件夹到各部分
    for idx, project in enumerate(project_folders):
        part_num = (idx // part_size) + 1
        part_dir = os.path.join(src_dir, f'part{part_num}')
        shutil.move(os.path.join(src_dir, project), os.path.join(part_dir, project))

    print(f'Done! {total_projects} projects have been divided into {num_parts} parts.')

if __name__ == '__main__':
    src_directory = "flatten_test_dataset/DeleteSPDXContract/Delte_spdx_Contracts"
    divide_into_parts(src_directory)
