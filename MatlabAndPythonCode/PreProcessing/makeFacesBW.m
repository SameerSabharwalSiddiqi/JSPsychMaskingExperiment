disgustFaces = dir(fullfile('jspsych/disgustFaces','*.JPG'));
neutralFaces = dir(fullfile('jspsych/neutralFaces','*.JPG'));
mkdir 'BWdisgustFaces'
mkdir 'BWneutralFaces'

nDisgustFaces = length(disgustFaces);
for i = 1:nDisgustFaces
    %select and scramble face
    face = disgustFaces(i).name;
    faceDir = fullfile('jspsych/disgustFaces',face);
    img = imread(faceDir); %vertically flipped for sanity check
    BWimg = im2gray(img);
    imwrite(BWimg,faceDir,'JPG');
end

nNeutralFaces = length(neutralFaces);
for i = 1:nNeutralFaces
    %select and scramble face
    face = neutralFaces(i).name;
    faceDir = fullfile('jspsych/neutralFaces',face);
    img = imread(faceDir); %vertically flipped for sanity check
    BWimg = im2gray(img);
    imwrite(BWimg,faceDir,'JPG');
end