import os, shutil
from distutils.dir_util import copy_tree
import nbformat
import re

# if not os.getenv("QUARTO_PROJECT_RENDER_ALL"):
#     exit()

def R_rep(text):
    text = text.replace('\n','~~~~~~')
    A = re.findall(r'::: {.cell-output .cell-output-stdout}(.*?):::',text)
    B = re.findall(r'::: {.cell-output .cell-output-stderr}(.*?)```(.*?)```',text)
    C = re.findall(r'::: {.cell-output-display}(.*?):::',text)
    D = re.findall(r':::: {.columns}(.*?)::::',text)
    # E = re.findall(r':::: {.columns}(.*?)::::',text)
    # for rem in [D,A,B,C]:
    for rem in [D,A,B,C]:
        for i,a in enumerate(rem):
            if isinstance(a, tuple):
                for part in a:
                    text=text.replace(part,'\n')
            else:
                text=text.replace(a,'')
    text=text.replace(':::: {.columns}','')
    text=text.replace('::::','')

    text=text.replace('.r .cell-code','r')
    text=text.replace('::: {.cell}','')
    text=text.replace('::: {.cell-output .cell-output-stdout}','')
    text=text.replace('::: {.cell-output .cell-output-stderr}','')
    text=text.replace('::: {.cell-output-display}','')
    text=text.replace(':::','')

    text=text.replace('\n\n---\n\n','\n\n')
    text=text.replace('```\n```','```\n\n')
    text=text.replace('~~~~~~','\n')
    for rep in ['execute:\n','keep-md: true\n','echo: true\n','output: False']:
        text = text.replace(rep,'')

    text=text.replace('\n\n\n\n','\n\n')
    return (text)

def nb_Rep(nbin,nbout):
    
    nb = nbformat.read(nbin,as_version=4)
    drop_cells = []
    for i, c in enumerate(nb.cells):
        if c['cell_type'] == 'raw':
            drop_cells.append(i)
        elif c['cell_type'] == 'markdown':
            if ':::: {.columns}' in c['source']:
                drop_cells.append(i)
        elif c['cell_type'] == 'code':
            c['source'] = c['source'].replace('#| include: false','')

    for i in drop_cells[::-1]:
        nb.cells.pop(i)

    nbformat.write(nb,  nbout)

Write_Dir = '../Assignment'
Out_Dir = 'docs/'
for In_Dir in ['Assignments/','AssignmentsR_out/']:
    for file in os.listdir(In_Dir):
        mv = 0
        Write_Out = f'{Write_Dir}{file.split(".")[0]}/'
        if file.endswith(".html.md"):
            with open(f"{In_Dir}/{file}",'r',encoding='utf-8') as T:
                # text = T.read()
                text = R_rep(T.read())
            if file.startswith('_'):
                fn = file[1:].split(".html.md")[0]
            else:
                fn = file.split(".html.md")[0]
            with open(Write_Out+fn+'.Rmd','w',encoding='utf-8') as out:
                out.write(text)
            os.remove(f"{In_Dir}/{file}")
            print(f'Converted {file} to RMD')
            mv = 1
        elif file.endswith(".ipynb"):
            nb_Rep(In_Dir+file, Write_Out+file)
            shutil.move(In_Dir+file, Write_Out+file)

            mv = 1
            print(f'Moved {file}')
            