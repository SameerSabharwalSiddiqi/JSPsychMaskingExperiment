#since some of the face-images in KDEF database are bad (luminance too high etc.), one can delete them in the neutral/disgust folders manually
#then use this code to return a stringe of all the remainig JPG elements. One can copy/paste this string into the maskedFace experiment file to 
#run the experiment without the problematic faces.

import glob, os, shutil, PIL
from PIL import Image  

arrDisgust = os.listdir('jspsych/disgustFaces')
print('below are the DISGUST faces')
print(arrDisgust)
input("Press Enter to continue...")

arrScrambledDisgust = os.listdir('jspsych/scrambledDisgustFaces')
print('below are the SCRAMBLED DISGUST faces')
print(arrScrambledDisgust)
input("Press Enter to continue...")


arrNeutral = os.listdir('jspsych/neutralFaces')
print('below are the NEUTRAL faces')
print(arrNeutral)
input("Press Enter to continue...")

arrScrambledNeutral = os.listdir('jspsych/scrambledNeutralFaces')
print('below are the SCRAMBLED Neutral faces')
print(arrScrambledNeutral)