clear all
%Open Chicago Face Directory
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\CFDVersion2.5');
CFDtable = readtable('CFDNormingDataForMatlab');


%step1: filter table to exclude candidates who are too unusual
CFDtable = CFDtable(CFDtable.Unusual>2,:); 
CFDtable = CFDtable(CFDtable.Unusual<3,:);

%step2: include candidates only in certain age rage (22 to 35)
%No data for actual age! so using rated age instead 
CFDtable = CFDtable(CFDtable.AgeRated>=22,:);
CFDtable = CFDtable(CFDtable.AgeRated<=35,:);

%step3: exclude candidates whose rated gender does not match 100% with
%actual gender
tableIndToRemove = [nan];
indCntr = 1;
for iFace = 1:height(CFDtable)
    gender = CFDtable(iFace,:).GenderSelf;
    femaleProb = CFDtable(iFace,:).FemaleProb;
    maleProb = CFDtable(iFace,:).MaleProb;
    if strcmp('F',gender)
        if femaleProb<1
            tableIndToRemove(indCntr) = iFace;
            indCntr = indCntr + 1;
        end
    elseif strcmp('M',gender)
        if maleProb<1
            tableIndToRemove(indCntr) = iFace;
            indCntr = indCntr + 1;
        end
    else
        tableIndToRemove(indCntr) = iFace; % not sure if there are transexual identifying people etc. in dataset, this check is for that possibility
        indCntr = indCntr + 1;
    end
end
CFDtable([tableIndToRemove],:) = [];

%Make Cohorts for ethnicity/gender 

%1. Asian-Female Cohort
cohortMax = 20;
asianFemaleCntr = 0;
asianMaleCntr = 0;
blackFemaleCntr = 0;
blackMaleCntr = 0;
latFemaleCntr = 0;
latMaleCntr = 0;
whiteMaleCntr = 0;
whiteFemaleCntr = 0;

tableIndToRemove = [nan]; %reset this
indCntr = 1;

for iFace = 1:height(CFDtable)
    gender = CFDtable(iFace,:).GenderSelf;
    ethnicity = CFDtable(iFace,:).EthnicitySelf;
    if strcmp(gender,'F')
        if strcmp(ethnicity,'A')
            asianFemaleCntr = asianFemaleCntr + 1;
            if asianFemaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        elseif strcmp(ethnicity,'B')
             blackFemaleCntr = blackFemaleCntr + 1;
            if blackFemaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        elseif strcmp(ethnicity,'L')
            latFemaleCntr = latFemaleCntr + 1;
            if latFemaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        elseif strcmp(ethnicity,'W')
            whiteFemaleCntr = whiteFemaleCntr + 1;
            if whiteFemaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        end
    elseif strcmp(gender,'M')
        if strcmp(ethnicity,'A')
            asianMaleCntr = asianMaleCntr + 1;
            if asianMaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        elseif strcmp(ethnicity,'B')
            blackMaleCntr = blackMaleCntr + 1;
            if blackMaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        elseif strcmp(ethnicity,'L')
            latMaleCntr = latMaleCntr + 1;
            if latMaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        elseif strcmp(ethnicity,'W')
            whiteMaleCntr = whiteMaleCntr + 1;
            if whiteMaleCntr>cohortMax
                tableIndToRemove(indCntr) = iFace;
                indCntr = indCntr + 1;
            end
        end
    end
end
CFDtable([tableIndToRemove],:) = [];

%finally, save photos in new directory 
%one directory for women and one for men - since names will be gender
%specific
OutputFaceDirMale = 'C:\Users\16466\Desktop\MaskingExperimentJsPsych\JsPsych\CFDfacesMale';
OutputFaceDirFemale = 'C:\Users\16466\Desktop\MaskingExperimentJsPsych\JsPsych\CFDfacesFemale';
if exist(OutputFaceDirMale,'dir') || exist(OutputFaceDirFemale,'dir')
    rmdir(OutputFaceDirMale)
    rmdir(OutputFaceDirFemale)
end
mkdir(OutputFaceDirMale);
mkdir(OutputFaceDirFemale);
for iFace = 1:height(CFDtable)
    Keytag = CFDtable(iFace,:).Model;
    Gender = CFDtable(iFace,:).GenderSelf;
    path1 = 'C:\Users\16466\Desktop\MaskingExperimentJsPsych\CFDVersion2.5\Images\CFD';
    path2 = Keytag;
    folderDir = fullfile(path1,path2);
    a = dir(folderDir{1});
    for iDirElement = 3:length(a)
        name = a(iDirElement).name;
        if contains(name,'-N.jpg')
            imageDir = fullfile(folderDir,name);
            CFDface = imread(imageDir{1});
            if strcmp(Gender,'M')
            outputImageDir = fullfile(OutputFaceDirMale,name);
            imwrite(CFDface,outputImageDir,'JPEG');
            elseif strcmp(Gender,'F')
            outputImageDir = fullfile(OutputFaceDirFemale,name);
            imwrite(CFDface,outputImageDir,'JPEG');
            end
        end
    end
end

maleFaces = dir('C:\Users\16466\Desktop\MaskingExperimentJsPsych\JsPsych\CFDfacesMale');
for i = 3:length(maleFaces)
maleFaceNames{i-2} = maleFaces(i).name;
end
maleString = cellfun(@string,maleFaceNames);
maleString = join(maleString,"','");
maleString = append("['",maleString,"']");

femaleFaces = dir('C:\Users\16466\Desktop\MaskingExperimentJsPsych\JsPsych\CFDfacesFemale');
for i = 3:length(femaleFaces)
    femaleFaceNames{i-2} = femaleFaces(i).name;
end
femaleString = cellfun(@string,femaleFaceNames);
femaleString = join(femaleString,"','");
femaleString = append("['",femaleString,"']");

fprintf(femaleString);
fprintf('\n')
fprintf(maleString);
fprintf('\n')
