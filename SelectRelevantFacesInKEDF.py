#Debugging issues: unable to define or set path variable 

import glob, os, shutil, PIL
from PIL import Image  

#Create Directory for Disgust Faces
print('writing/rewriting directory for disgust faces')

dir = 'disgustFaces'
if os.path.exists(dir):
    shutil.rmtree(dir)
os.makedirs(dir)

for root, dirs, files in os.walk("KDEF"):
    for file in files:
        if file.endswith("DIS.JPG"): ##DI = disgust, S= straight (as opposed to profile view)
            disgustJPG = os.path.join(root,file)
            disgustJPGdestination =os.path.join('disgustFaces',file)
            #print(disgustJPG) #use for debugging
            #print(disgustJPGdestination)
            img = Image.open(disgustJPG)
            img = img.save(disgustJPGdestination)

arrDisgust = os.listdir('disgustFaces')
print(arrDisgust)

#Create Directory for Neutral Faces
print('writing/rewriting directory for neutral faces')

dir = 'neutralFaces'
if os.path.exists(dir):
    shutil.rmtree(dir)
os.makedirs(dir)

for root, dirs, files in os.walk("KDEF"):
    for file in files:
        if file.endswith("NES.JPG"): ##NE = Neutral, S= straight (as opposed to profile view)
            neutralJPG = os.path.join(root,file)
            neutralJPGdestination =os.path.join('neutralFaces',file)
            #print(neutralJPG) #use for debugging
            #print(neutralJPGdestination)
            img = Image.open(neutralJPG)
            img = img.save(neutralJPGdestination)

arrNeutral = os.listdir('neutralFaces')
print(arrNeutral)