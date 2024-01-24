import os, re

if not os.getenv("QUARTO_PROJECT_RENDER_ALL"):
  exit()

Dirs = ['_Equations/']
Names = ['EquationList.qmd']

doc = '\n'
    
for Dir,Filename in zip(Dirs,Names):
    for file in os.listdir(Dir):
        if file not in Names and file.endswith(".qmd"):
            with open(Dir+file,'r') as T:
                text = T.read().replace('\n','')
                EQ = re.findall(r'\$\$(.*?)\$\$',text)
                LB = re.findall(r'eq-(.*?)}',text)
                for eq,lb in zip (EQ,LB):
                    blurb = ''
                    nm = lb.replace('-',' ')
                    blurb = f'## {nm}\n\n'
                    blurb += f'$$\n{eq}\n$$'+'{#eq-'+lb+'}\n\n'
                    doc += blurb

    with open(Dir+Filename,'w+') as out:
        out.write(doc)
    