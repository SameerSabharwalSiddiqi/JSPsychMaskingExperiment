%Based on folders disgustFaces and neutralFaces, return and write
%phase-scrambled faces in the same order. 

%Control Panel
verticallyFlipInsteadofScramblingFaces = 0; %Set this to 1 to vertically flip faces instead of scrambling them, useful if you want to just do a sanity check to make sure same face is being used for mask and cue
rewriteFilesAndReturnScript = 1; %if set to 0, this script will just return the directory contents for copy/pasting into cognition.run
BWfaces = 1;

if rewriteFilesAndReturnScript == 1
disgustFaces = dir(fullfile('jspsych/disgustFaces','*.JPG'));
neutralFaces = dir(fullfile('jspsych/neutralFaces','*.JPG'));

mkdir 'jspsych/scrambledDisgustFaces'
mkdir 'jspsych/scrambledNeutralFaces'

nDisgustFaces = length(disgustFaces);
for i = 1:nDisgustFaces
    %select and scramble face
    face = disgustFaces(i).name;
    faceDir = fullfile('jspsych/disgustFaces',face);
    if verticallyFlipInsteadofScramblingFaces == 0
        if BWfaces == 0
        scrambledFace = colorPhaseScrambleFace(faceDir);
        elseif BWfaces ==1
        scrambledFace = bwPhaseScrambleFace(faceDir);
        end
    elseif verticallyFlipInsteadofScramblingFaces == 1
    img = imread(faceDir); %vertically flipped for sanity check
    scrambledFace = flip(img,1); %Vertically flipped for sanity check
    end
    %generate unique string for naming file
    strName = strcat('scrambled',face);
    scrambledDir = fullfile('jspsych/scrambledDisgustFaces',strName);
    imwrite(scrambledFace,scrambledDir,'JPG');
end

nNeutralFaces = length(neutralFaces);
for i = 1:nNeutralFaces
    %select and scramble face
    face = neutralFaces(i).name;
    faceDir = fullfile('jspsych/neutralFaces',face);
    if verticallyFlipInsteadofScramblingFaces == 0
        if BWfaces == 0
        scrambledFace = colorPhaseScrambleFace(faceDir);
        elseif BWfaces ==1
        scrambledFace = bwPhaseScrambleFace(faceDir);
        end
    elseif verticallyFlipInsteadofScramblingFaces == 1
    img = imread(faceDir); %vertically flipped for sanity check
    scrambledFace = flip(img,1); %Vertically flipped for sanity check
    end    %scrambledFace = flip(faceDir,1);
    %generate unique string for naming file
    strName = strcat('scrambled',face);
    scrambledDir = fullfile('jspsych/scrambledNeutralFaces',strName);
    imwrite(scrambledFace,scrambledDir,'JPG');
end
end