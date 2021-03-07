#Debugging issues: unable to define or set path variable 

import glob, os, shutil, PIL
from PIL import Image  

#Create Directory for Disgust Faces
print('creating directory that contains ALL neutral faces')

dir = 'neutralFacesCFD'
if os.path.exists(dir):
    shutil.rmtree(dir)
os.makedirs(dir)

for root, dirs, files in os.walk("CFDVersion2.5/Images/CFD"):
    for file in files:
        if file.endswith("-N.JPG"): ##N = disgust
            neutralJPG = os.path.join(root,file)
            neutralJPGdestination =os.path.join('neutralFacesCFD',file)
            img = Image.open(disgustJPG)
            img = img.save(disgustJPGdestination)

