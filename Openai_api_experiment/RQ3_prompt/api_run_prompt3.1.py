"""_summary_
  和Openai通讯的主体函数,包括prompt模板,形成prompt,和api通讯并保存结果三部分
Returns:
    _type_: json文件
"""


from openai import OpenAI
import asyncio
import json
import os

# 设置OpenAI API密钥和Base URL
#api_key = os.getenv("OPENAI_API_KEY", "your_openai_api_key")
#base_url = os.getenv("OPENAI_BASE_URL", "https://api.openai.com")

client = OpenAI(api_key="sk-Ip4l1VxSdmpIzEZAjJCLKSD4miskxPvfYVBtKOmX5EbwmEkM", base_url="https://api.chatanywhere.tech/v1")

# System Prompt 和 User Prompt 模板,Ver2.0

#system_prompt = "You are a smart contract auditor. You will be asked to review the code segment for specific vulnerabilities. You can mimic answering them in the background five times and provide me with the most frequently appearing answer. Furthermore, please strictly adhere to the output format specified in the question; there is no need to explain your answer."

# user_prompt_template = """
# In the following smart contract code (with a paragraph called "Code:"), does it have a vulnerability called "{name}"?
# - First, please answer the question in one word, yes or no, with a key called "Answer:".
# - If yes, please use the given code to describe the root cause of this vulnerability with a key called "Description:".
# - If not, please output an empty paragraph with a key called "NoVulnerability:".
# - Please strictly follow the format I mentioned using "Description:"(for the yes case), or "NoVulnerability:" (for the no case).
# Code:"{code_segment}"
# """




# System Prompt 和 User Prompt 模板,Ver3.0
system_prompt = "You are a smart contract auditor. You will review code segments for specific vulnerabilities. Simulate analyzing the code five times and provide the most frequent result. Adhere strictly to the output format requested in the question, without any additional explanations."

user_prompt_template = """
In the following smart contract code snippet (provided after the keyword "Code:"), determine if there is a vulnerability specifically called "{name}". 

Please simulate the process five times in the background and return the most frequent result among the simulations. 
Follow these steps:
1. Think step by step about the vulnerability detection process.
2. Provide your final answer in one word: "Yes" or "No", using the key "Answer:".

Code: "{code_segment}"
"""

# 输入问题列表
#code_segments = [
#    # 在这里添加代码段
#]

#vulnerabilities = [
#    # 在这里添加漏洞名称
#]

# 读取JSON文件
with open('scripts/tool_result_check/solhint/vulcode.json', 'r', encoding='utf-8') as f: ###输入的json文件目录
    data = json.load(f)

# 提取code_segments和vulnerabilities
code_segments = [item['code_segment'] for item in data]
vulnerabilities = [item['name'] for item in data]
filename = [item['filename'] for item in data]
check = [item['check'] for item in data]

async def fetch_completion(code_segment: str, vulnerability: str, filename: str, check: str) -> dict:
    try:
        user_prompt = user_prompt_template.format(name=vulnerability, code_segment=code_segment)
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ]
        response = client.chat.completions.create(model="gpt-4o-ca", messages=messages)
        return {
            
            "code_segment": code_segment,
            "filename": filename,
            "vulnerability": vulnerability,
            "check": check,
            "response": response.choices[0].message.content
        }
    except Exception as e:
        return {
            
            "code_segment": code_segment,
            "filename": filename,
            "vulnerability": vulnerability,
            "check": check,
            "error": str(e)
        }

async def main():
    tasks = [fetch_completion(code_segment, vulnerability, filename, check) for code_segment, vulnerability, filename, check in zip(code_segments, vulnerabilities, filename, check)]
    results = await asyncio.gather(*tasks)

    # 保存结果到本地 JSON 文件
    with open('Openai_api_experiment/GPT_results/solhint/solhint_ver3.1.json', 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    inputfile = ""
    asyncio.run(main())