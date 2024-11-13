"""_summary_
  该脚本用于从漏洞检测结果中收集每个汇报漏洞相关信息以及索引到对应的漏洞代码，形成一个 json，用于插入到 prompt 模板中
Returns:
    _type_: json 文件
"""



import os
import json
import re

def remove_comments(code):
    return re.sub(r'///.*', '', code)

def extract_code_segment(filepath, start_line, end_line):
    with open(filepath, 'r') as file:
        lines = file.readlines()
        return ''.join(lines[start_line-1:end_line])

def extract_entire_contract(filepath, contract_name):
    with open(filepath, 'r') as file:
        code = remove_comments(file.read())
        #VER1.0 contract_pattern = re.compile(r'contract\s+' + re.escape(contract_name) + r'\s*{', re.MULTILINE)
        #VER1.1 contract_pattern = re.compile(r'\bcontract\s+' + re.escape(contract_name) + r'\b[^{]*{', re.MULTILINE)
        contract_pattern = re.compile(r'\b(contract|library)\s+' + re.escape(contract_name) + r'\b[^{]*{', re.MULTILINE)
        match = contract_pattern.search(code)
        if match:
            start = match.start()
            brace_count = 1
            i = match.end()
            while i < len(code) and brace_count > 0:
                if code[i] == '{':
                    brace_count += 1
                elif code[i] == '}':
                    brace_count -= 1
                i += 1
            return code[start:i]
    return None

def extract_entire_file(filepath):
    with open(filepath, 'r') as file:
        code = file.read()
        return remove_comments(code)

def process_findings(findings, output):
    for finding in findings:
        filename = finding.get('filename')
        contract = finding.get('contract')
        function = finding.get('function')
        line = finding.get('line')
        line_end = finding.get('line_end', line)
        name = finding.get('name')

        if filename:
            #if line and function:
                #code_segment = extract_code_segment(filename, line, line_end)
            if contract:#elif
                code_segment = extract_entire_contract(filename, contract)
                if not(code_segment) :
                  code_segment = extract_entire_file(filename)
            else:
                code_segment = extract_entire_file(filename)
            
            output.append({
                "filename": filename,
                "contract": contract,
                "function": function,
                "line": line,
                "line_end": line_end,
                "name": name,
                "code_segment": code_segment
            })

def main(parent_folder):
    output_data = []

    for subdir, _, _ in os.walk(parent_folder):
        results_file = os.path.join(subdir, 'result.json')
        if os.path.isfile(results_file):
            with open(results_file, 'r') as file:
                data = json.load(file)
                findings = data.get('findings', [])
                process_findings(findings, output_data)

    with open('scripts/tool_result_check/maian/vulcode.json', 'w') as outfile: ### 输出的 json 名称和目录
        json.dump(output_data, outfile, indent=4)

if __name__ == "__main__":
    parent_folder = 'Dapp_ToolResult/maian' ### 工具存储运行结果的目录
    main(parent_folder)
