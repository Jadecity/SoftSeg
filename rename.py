import os
import os.path

files = os.listdir('.')
nn = 1
for file in files:
    if file.endswith('.jpg'):
        os.rename(file, str(nn)+'.jpg')
        nn = nn + 1
