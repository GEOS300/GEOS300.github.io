import os

if not os.getenv("QUARTO_PROJECT_RENDER_ALL"):
    exit()


In_Dir = 'Assignments/'
Out_Dir = 'AssignmentsR_out/'

py_head = '''
jupyter: python3
execute:
  keep-ipynb: true
echo: false
'''

R_head = '''
execute:
  keep-md: true
echo: true
output: False
'''

py_code = '_py.'
R_code = '_R.'

print(In_Dir)
for file in os.listdir(In_Dir):
    if file.endswith(".qmd") and file.startswith('index') == False:
        with open(f"{In_Dir}/{file}",'r',encoding='utf-8') as T:

            text = T.read().replace(py_head,R_head)
            print(text[:100])
            text = text.replace(py_code,R_code)
            text = text.replace(' _Includes','../Assignments/_Includes')
            
        with open(Out_Dir+file,'w',encoding='utf-8') as out:
            out.write(text)
        print(f'Converted {file} to RMD')
