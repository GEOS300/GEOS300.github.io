import os, shutil
import re

In_Dir = 'Assignments/'
Out_Dir = '../AssignmentCode/'
print(In_Dir)
for file in os.listdir(In_Dir):
    if file.endswith(".html.md"):
        with open(f"{In_Dir}/{file}",'r',encoding='utf-8') as T:
            text = T.read().replace('\n','~~~~~~')
            A = re.findall(r'::: {.cell-output .cell-output-stdout}(.*?):::',text)
            for i,a in enumerate(A):
                text=text.replace(a,'\n')
            text=text.replace('.r','r')
            text=text.replace('::: {.cell}','\n')
            text=text.replace('::: {.cell-output .cell-output-stdout}','\n')
            text=text.replace(':::','\n')
            text=text.replace('~~~~~~','\n')
            
        with open(Out_Dir+file.split(".html.md")[0]+'.rmd','w',encoding='utf-8') as out:
            out.write(text)
        print(f'Converted {file} to RMD')
    elif file.endswith(".ipynb"):
        shutil.copyfile(In_Dir+file, Out_Dir+file)

    
        print(f'Moved {file}')

    

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
