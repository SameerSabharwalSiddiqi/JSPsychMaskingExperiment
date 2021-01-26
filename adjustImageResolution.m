CFDfaces = dir(fullfile('jspsych\CFDfaces','*.JPG'));

mkdir('jspsych\resizedCFDfaces')
saveDir = 'jspsych\resizedCFDfaces';

nCFDfaces = length(CFDfaces);

for i = 1:nCFDfaces
    %select and scramble face
    face = CFDfaces(i).name;
    faceDir = fullfile('jspsych/CFDfaces',face);
    img = imread(faceDir); %vertically flipped for sanity check
    resizedImg = imresize(img,0.25);
    fullSaveDir = fullfile(saveDir,face);
    imwrite(resizedImg,fullSaveDir,'JPG');
end

