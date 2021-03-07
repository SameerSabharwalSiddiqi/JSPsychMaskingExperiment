CFDfaces = dir(fullfile('jspsych\supplementaryImages','*.JPG'));

mkdir('jspsych\supplementaryImages')
saveDir = 'jspsych\supplementaryImages';

nCFDfaces = length(CFDfaces);

for i = 1:nCFDfaces
    %select and scramble face
    face = CFDfaces(i).name;
    faceDir = fullfile('jspsych/supplementaryImages',face);
    img = imread(faceDir); %vertically flipped for sanity check
    resizedImg = imresize(img,0.5);
    fullSaveDir = fullfile(saveDir,face);
    imwrite(resizedImg,fullSaveDir,'JPG');
end

