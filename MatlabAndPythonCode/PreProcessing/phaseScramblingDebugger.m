%Use this script to try out different permutations of phaseScramble and see
%the result quickly and without rewriting files
disgustFaces = dir(fullfile('jspsych/disgustFaces','*.JPG'));
    face = disgustFaces(90).name;
    faceDir = fullfile('jspsych/disgustFaces',face);
    %scrambledFace = phaseScrambleFace(faceDir);
    img = imread(faceDir); %vertically flipped for sanity check
    scrambledFace = flip(img,1); %Vertically flipped for sanity check
    figure(1)
    subplot(1,2,1)
    imshow(faceDir);
    title('originalFace')
    subplot(1,2,2)
    imshow(scrambledFace);
    title('scrambledFace');


