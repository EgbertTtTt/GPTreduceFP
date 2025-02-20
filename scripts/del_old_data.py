import json
import os

def process_json_file(input_path, output_path):
    """
    处理 JSON 文件，过滤掉 "filename" 以 "Dapp_dataset/negative" 开头的项。

    参数：
        input_path (str): 输入 JSON 文件路径。
        output_path (str): 输出处理后 JSON 文件路径。

    返回：
        None
    """
    try:
        # 读取 JSON 文件
        with open(input_path, 'r', encoding='utf-8') as infile:
            data = json.load(infile)

        # 过滤掉以 "Dapp_dataset/negative" 开头的项
        filtered_data = [item for item in data if not item.get("filename", "").startswith("Dapp_dataset/negative")]

        # 将处理后的数据写入新的 JSON 文件
        with open(output_path, 'w', encoding='utf-8') as outfile:
            json.dump(filtered_data, outfile, ensure_ascii=False, indent=4)

        print(f"处理完成。结果已保存到 {output_path}")
    except FileNotFoundError:
        print(f"输入文件未找到：{input_path}")
    except json.JSONDecodeError:
        print("JSON 文件格式错误，请检查输入文件。")
    except Exception as e:
        print(f"发生错误：{e}")

def process_json_directory(input_dir, output_dir):
    """
    遍历指定目录，对其中的所有 JSON 文件进行处理，并保持目录结构输出到新的目录。

    参数：
        input_dir (str): 输入目录路径。
        output_dir (str): 输出目录路径。

    返回：
        None
    """
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for root, _, files in os.walk(input_dir):
        for file in files:
            if file.endswith('.json'):
                input_file_path = os.path.join(root, file)
                relative_path = os.path.relpath(root, input_dir)
                output_file_dir = os.path.join(output_dir, relative_path)
                if not os.path.exists(output_file_dir):
                    os.makedirs(output_file_dir)
                output_file_path = os.path.join(output_file_dir, file)

                process_json_file(input_file_path, output_file_path)

if __name__ == "__main__":
    """
    脚本入口，负责获取用户输入的目录路径，并调用处理函数。

    功能：
        1. 提示用户输入 JSON 文件的目录路径和输出目录路径。
        2. 调用 process_json_directory 函数处理目录中的文件。

    返回：
        None
    """
    # 输入和输出目录路径
    input_dir_path = "old_data_from_ISSTA/GPT_results"
    output_dir_path = "GPT_results"

    # 调用处理函数
    process_json_directory(input_dir_path, output_dir_path)
