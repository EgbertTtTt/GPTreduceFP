"""_summary_
  和 Openai 通讯的主体函数，包括 prompt 模板，形成 prompt，和 api 通讯并保存结果三部分
Returns:
    _type_: json 文件
"""

import sys
from openai import OpenAI
import asyncio
import json
import os

toolname = sys.argv[1]  # 从命令行参数中获取 toolname
# 设置 OpenAI API 密钥和 Base URL
#api_key = os.getenv("OPENAI_API_KEY", "your_openai_api_key")
#base_url = os.getenv("OPENAI_BASE_URL", "https://api.openai.com")

client = OpenAI(api_key="sk-Ip4l1VxSdmpIzEZAjJCLKSD4miskxPvfYVBtKOmX5EbwmEkM", base_url="https://api.chatanywhere.tech/v1")





# System Prompt 和 User Prompt 模板，Ver4.0
system_prompt = "You are a smart contract auditor specializing in identifying vulnerabilities within specific functions of a smart contract.You will simulate the evaluation process five times in the background and provide the most frequent answer. It is important to strictly follow the output format provided in the question and only return the requested response without additional explanations."

user_prompt_template = """
In the "{function}" function of the following smart contract code (provided under "Code:"), is there a vulnerability called "{name}"? 

Provide your final answer in one word: "Yes" or "No", using the key "Answer:".

Code: "{code_segment}"
"""


# 读取 JSON 文件
input_file = f'scripts/tool_result_check/{toolname}/vulcode.json'
output_file = f'Openai_api_experiment/GPT_results/{toolname}/{toolname}_ver4.1.2.json'


# 读取 JSON 文件
with open(input_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

# 提取 code_segments 和 vulnerabilities
code_segments = [item['code_segment'] for item in data]
vulnerabilities = [item['name'] for item in data]
filename = [item['filename'] for item in data]
function = [item['function'] for item in data]
check = [item['check'] for item in data]

async def fetch_completion(code_segment: str, vulnerability: str, filename: str, function: str, check: str) -> dict:
    try:
        user_prompt = user_prompt_template.format(name=vulnerability, code_segment=code_segment, function=function)
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ]
        response = client.chat.completions.create(model="gpt-4o-ca", messages=messages)
        return {
            
            "code_segment": code_segment,
            "function": function,
            "filename": filename,
            "vulnerability": vulnerability,
            "check": check,
            "response": response.choices[0].message.content
        }
    except Exception as e:
        return {
            
            "code_segment": code_segment,
            "function": function,
            "filename": filename,
            "vulnerability": vulnerability,
            "check": check,
            "error": str(e)
        }

async def main():
    tasks = [fetch_completion(code_segment, vulnerability, filename, function, check) for code_segment, vulnerability, filename, function, check in zip(code_segments, vulnerabilities, filename, function, check)]
    results = await asyncio.gather(*tasks)
 
    # 保存结果到本地 JSON 文件
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    asyncio.run(main())