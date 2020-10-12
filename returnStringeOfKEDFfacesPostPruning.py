#since some of the face-images in KDEF database are bad (luminance too high etc.), one can delete them in the neutral/disgust folders manually
#then use this code to return a stringe of all the remainig JPG elements. One can copy/paste this string into the maskedFace experiment file to 
#run the experiment without the problematic faces.

import glob, os, shutil, PIL
from PIL import Image  

arrDisgust = os.listdir('jspsych/disgustFaces')
print('below are the DISGUST faces')
print(arrDisgust)

arrNeutral = os.listdir('jspsych/neutralFaces')
print('below are the NEUTRAL faces')
print(arrNeutral)
