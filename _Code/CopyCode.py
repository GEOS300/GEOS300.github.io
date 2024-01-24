import os, shutil
from distutils.dir_util import copy_tree
import re

In_Dir = 'Assignments/'
Write_Dir = '../AssignmentCode/'
Out_Dir = 'docs/'
for file in os.listdir(In_Dir):
    mv = 0
    if file.endswith(".html.md"):
        with open(f"{In_Dir}/{file}",'r',encoding='utf-8') as T:
            text = T.read()
            text = text.replace('\n','~~~~~~')
            A = re.findall(r'::: {.cell-output .cell-output-stdout}(.*?):::',text)
            B = re.findall(r'::: {.cell-output .cell-output-stderr}(.*?)```(.*?)```',text)
            C = re.findall(r'::: {.cell-output-display}(.*?):::',text)
            for rem in [A,B,C]:
                for i,a in enumerate(rem):
                    if isinstance(a, tuple):
                        for part in a:
                            text=text.replace(part,'\n')
                    else:
                        text=text.replace(a,'\n')
            text=text.replace('.r .cell-code','r')
            text=text.replace('::: {.cell}','\n')
            text=text.replace('::: {.cell-output .cell-output-stdout}','\n')
            text=text.replace('::: {.cell-output .cell-output-stderr}','\n')
            text=text.replace('::: {.cell-output-display}','\n')
            text=text.replace(':::','\n')
            text=text.replace('```~~~~~~```','\n')
            text=text.replace('~~~~~~','\n')
            
        with open(Write_Dir+file.split(".html.md")[0]+'.rmd','w',encoding='utf-8') as out:
            out.write(text)
        os.remove(f"{In_Dir}/{file}")
        print(f'Converted {file} to RMD')
        mv = 1
    elif file.endswith(".ipynb"):
        shutil.move(In_Dir+file, Write_Dir+file)

        mv = 1
        print(f'Moved {file}')
    if mv == 1:
        print('Moving ',Out_Dir+In_Dir+file.split('.')[0]+'_files')
        copy_tree(Out_Dir+In_Dir+file.split('.')[0]+'_files', Write_Dir+file.split('.')[0]+'_files')
    

# import pandas as pd

# if not os.getenv("QUARTO_PROJECT_RENDER_ALL"):
#     exit()

# KeyDir = '../AnswerKeys'

# Home = os.getenv("QUARTO_PROJECT_OUTPUT_DIR")

# for folder in ['Assignments']:
#     PDF_Dir = f"{Home}/{folder}"
#     Sheet_Dir = f"{folder}/_answer_keys"
#     Code_Dir = f"{folder}/_answer_keys"
#     OutDir = f"{KeyDir}/{folder}"
#     if not os.path.exists(OutDir):
#         os.mkdir(OutDir)
#     for file in os.listdir(PDF_Dir):
#         if file.endswith(".pdf"):
#             shutil.move(f"{PDF_Dir}/{file}",f"{OutDir}/{file}")
#     for file in os.listdir(Code_Dir):
#         if file.endswith(".R"):
#             shutil.move(f"{Code_Dir}/{file}",f"{OutDir}/{file}")
#     for file in os.listdir(Sheet_Dir):
#         if file.startswith("Lab"):
#             L = file.split('_')[0]
#             MarkingSheet = pd.read_csv(f"{Sheet_Dir}/MarkingSheet_{L}.csv",index_col='Question')
#             Answers = pd.read_csv(f"{Sheet_Dir}/{L}_AnswerList.csv",index_col='Question')
#             Key = MarkingSheet.join(Answers)
#             Key.to_csv(f"{OutDir}/MarkingSheet_{L}.csv")
#         elif file.endswith('.zip'):
#             shutil.move(f"{Sheet_Dir}/{file}",f"{OutDir}/{file}")
