%Based on folders disgustFaces and neutralFaces, return and write
%phase-scrambled faces in the same order. 

%Control Panel
rewriteFilesAndReturnScript = 0; %if set to 0, this script will just return the directory contents for copy/pasting into cognition.run

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
    scrambledFace = phaseScrambleFace(faceDir);
    
    %generate unique string for naming file
    strName = strcat('scrambled',face);
    scrambledDir = fullfile('jspsych/scrambledDisgustFaces',strName);
    imwrite(scrambledFace,scrambledDir,'JPG');
end

scrambledDisgustFaces = dir(scrambledDir);
if length('jspsych/scrambledDisgustFaces') ~= nDisgustFaces
    error('number of elements in disgust and phase_scrambled_disgust directories do not agree, please manually delete any existing phase_scrambled_disgust directory')
end

nNeutralFaces = length(neutralFaces);
for i = 1:nNeutralFaces
    %select and scramble face
    face = neutralFaces(i).name;
    faceDir = fullfile('jspsych/neutralFaces',face);
    scrambledFace = phaseScrambleFace(faceDir);
    
    %generate unique string for naming file
    strName = strcat('scrambled',face);
    scrambledDir = fullfile('jspsych/scrambledNeutralFaces',strName);
    imwrite(scrambledFace,scrambledDir,'JPG');
end

scrambledNeutralFaces = dir('jspsych/scrambledNeutralFaces');
if length(scrambledNeutralFaces) ~= nNeutralFaces
    error('number of elements in neutral and phase_scrambled_neutral directories do not agree, please manually delete any existing phase_scrambled_neutral directory')
end
end

for i = 1:length(scrambledNeutralFaces)
    neutralF
end