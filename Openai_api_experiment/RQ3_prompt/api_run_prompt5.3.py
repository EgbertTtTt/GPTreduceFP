"""_summary_
  和 Openai 通讯的主体函数，包括 prompt 模板，形成 prompt，和 api 通讯并保存结果三部分
    _type_: json 文件
    _update_:
      5.1:了解了 GPT api 的上下文存储机制后，改为原本最直接简单的方式，分割 vul_code 也没必要了
"""


from openai import OpenAI
import asyncio
import json
import os
import datetime
# 设置 OpenAI API 密钥和 Base URL
#api_key = os.getenv("OPENAI_API_KEY", "your_openai_api_key")
#base_url = os.getenv("OPENAI_BASE_URL", "https://api.openai.com")

client = OpenAI(api_key="sk-Ip4l1VxSdmpIzEZAjJCLKSD4miskxPvfYVBtKOmX5EbwmEkM", base_url="https://api.chatanywhere.tech/v1")





# System Prompt 模板
system_prompt = "You are a smart contract auditor specializing in identifying vulnerabilities within specific functions of a smart contract. When reviewing code, your task is to focus only on the function specified in the prompt. You will simulate the evaluation process five times in the background and provide the most frequent answer. It is important to strictly follow the output format provided in the question and only return the requested response without additional explanations."

# User Prompt 模板
user_prompt_template = """
In the "{function}" function of the following smart contract code (provided under "Code:"), is there a vulnerability called "{name}"(described under "Vulnerability Description:")? 

Provide your final answer in one word: "Yes" or "No", using the key "Answer:".

Vulnerability Description:
"{SWC_vul}"

Code:"{code_segment}"

"""
# 读取 JSON 文件
with open('SmartJsonResult/SmartJsonResult/mythril-0.24.7_AllResult.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

with open('SWC_vul.json', 'r', encoding='utf-8') as f:
    swc_vul_data = json.load(f)

with open('tools_SWC_matching_rules/Mythril.json', 'r', encoding='utf-8') as f:
    matching_rules = json.load(f)

# 提取 code_segments 和 vulnerabilities
code_segments = [item['code_segment'] for item in data]
vulnerabilities = [item['name'] for item in data]
filenames = [item['filename'] for item in data]
functions = [item['function'] for item in data]

# 异步函数调用 API
async def fetch_completion(code_segment: str, vulnerability: str, filename: str, function: str) -> dict:
    #system_prompt = None  # 定义默认值
    messages = []  # 存储消息的列表
    try:
        # 匹配 vulnerability 与 SWC 编号
        swc_key = matching_rules.get(vulnerability)
        if not swc_key:
            raise ValueError(f"No matching SWC key found for vulnerability: {vulnerability}")

        swc_vul_info = swc_vul_data.get(swc_key)
        if not swc_vul_info:
            raise ValueError(f"No SWC vulnerability information found for key: {swc_key}")

        # # 填充 system prompt
        # swc_vul_details = f"""
        # Title: {swc_vul_info['Title']}
        # Description: {swc_vul_info['Description']}
        # Remediation Suggestions: {', '.join(swc_vul_info['Remediation']['Suggestion'])}
        # Example File: {swc_vul_info['Samples']['FileName']}
        # Example Code: {swc_vul_info['Samples']['Code']}
        # """
        # system_prompt = system_prompt_template.format(name=vulnerability, SWC_vul=swc_vul_details)
        
        # 检查各个字段是否存在并构建 swc_vul_details
        title = swc_vul_info.get('Title', 'N/A')
        description = swc_vul_info.get('Description', 'N/A')
        remediation_suggestion = swc_vul_info.get('Remediation', {}).get('Suggestion', [])
        samples = swc_vul_info.get('Samples', {})

        swc_vul_details = f"""
        This vulnerability can be also called {title}.
        Flawed Example File: {samples.get('FileName', 'N/A')}
        Flawed Example Code: {samples.get('Code', 'N/A')}
        """
        #system_prompt = system_prompt_template.format(name=vulnerability, SWC_vul=swc_vul_details)
        
        
        
        
        

        # 填充 user prompt
        user_prompt = user_prompt_template.format(name=vulnerability, code_segment=code_segment, function=function, SWC_vul=swc_vul_details)

        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ]
        
        response = client.chat.completions.create(model="gpt-4o-ca", messages=messages, temperature=0)

        # 记录发送和返回的信息
        log_entry = {
            "timestamp": datetime.datetime.utcnow().isoformat(),
            "messages": messages,
            "response": response.choices[0].message.content
        }
        with open('log.json', 'a', encoding='utf-8') as log_file:
            json.dump(log_entry, log_file, ensure_ascii=False, indent=4)
            log_file.write('\n')  # 为了分割不同的记录

        return {
            "code_segment": code_segment,
            "function": function,
            "filename": filename,
            "vulnerability": vulnerability,
            "response": response.choices[0].message.content
        }
    except Exception as e:
        error_entry = {
            "timestamp": datetime.datetime.utcnow().isoformat(),
            "messages": messages,
            "error": str(e)
        }
        with open('log.json', 'a', encoding='utf-8') as log_file:
            json.dump(error_entry, log_file, ensure_ascii=False, indent=4)
            log_file.write('\n')  # 为了分割不同的记录

        return {
            "code_segment": code_segment,
            "function": function,
            "filename": filename,
            "vulnerability": vulnerability,
            "error": str(e)
        }

# 主函数
async def main():
    tasks = [fetch_completion(code_segment, vulnerability, filename, function) for code_segment, vulnerability, filename, function in zip(code_segments, vulnerabilities, filenames, functions)]
    results = await asyncio.gather(*tasks)

    # 保存结果到本地 JSON 文件
    with open('RQ3_data/mythril_Ver5.3_temp=0_token.json', 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    asyncio.run(main())