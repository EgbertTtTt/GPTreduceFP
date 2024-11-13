import subprocess

# 定义工具名称数组
toolnames = ["confuzzius", "conkas", "mythril", "osiris", "oyente", "sfuzz", "slither", "smartcheck", "solhint", "maian", "securify", "semgrep"]  # 替换为实际工具名

for toolname in toolnames:
    # 调用原始脚本并传入 toolname 参数
    result = subprocess.run(
        ["python", "Openai_api_experiment/RQ3_prompt/api_run_prompt4.1.3.py", toolname],  # 将 your_original_script.py 替换为你的脚本名
        capture_output=True,
        text=True
    )
    
    # 输出结果或错误信息
    if result.returncode == 0:
        print(f"{toolname} processed successfully.\nOutput:\n{result.stdout}")
    else:
        print(f"Error processing {toolname}:\n{result.stderr}")
