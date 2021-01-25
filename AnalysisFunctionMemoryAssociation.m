function [trialStruct,identifier] = AnalysisFunctionMemoryAssocation(dataCSV)
clear resultsCSV
if ~istable(dataCSV)
resultsCSV = readtable(dataCSV);
else
    resultsCSV = dataCSV;
end
%get identifier 
identifier = resultsCSV(1,:).responses{1};
nTrials = max(resultsCSV.iTrial);
nNodes = max(size(resultsCSV));
iTrial = 1;
clear trialStruct
clear durationStruct
clear durTrials
for iNode = 1:nNodes
    ExperimentPhase = resultsCSV.ExperimentPhase(iNode);
    Phase = resultsCSV.Phase(iNode);
    if strcmp(ExperimentPhase,'Test')
    if strcmp(Phase,'Cue')
    trialStruct(iTrial).CueDuration = resultsCSV.StimulusDurationSetting(iNode);
    lastTimePoint = resultsCSV.time_elapsed(iNode-1); %time elapsed before onset of cue time
    crntTimePoint = resultsCSV.time_elapsed(iNode); 
    recordedTime = crntTimePoint-lastTimePoint;
    
    stimulus = resultsCSV.stimulus(iNode);
        [imageFileDir,imageFileName] = fileparts(stimulus);
        if strncmp(imageFileName,'AF',2) || strncmp(imageFileName,'BF',2)
            maleFaceGender = 0;
        elseif strncmp(imageFileName,'AM',2) || strncmp(imageFileName,'BM',2)
            maleFaceGender = 1;
        else
            maleFaceGender = NaN;
        end
        trialStruct(iTrial).maleFaceGenderCue = maleFaceGender;
    trialStruct(iTrial).stimulusCue = stimulus;
    trialStruct(iTrial).recordedCueTime = recordedTime;
    end
    if strcmp(Phase,'backwardMask')
    stimulus = resultsCSV.stimulus(iNode);
        trialStruct(iTrial).stimulusNeutralMask = stimulus;
            [imageFileDir,imageFileName] = fileparts(stimulus);
        if strncmp(imageFileName,'AF',2) || strncmp(imageFileName,'BF',2)
            maleFaceGender = 0;
        elseif strncmp(imageFileName,'AM',2) || strncmp(imageFileName,'BM',2)
            maleFaceGender = 1;
        else
            maleFaceGender = NaN;
        end
        trialStruct(iTrial).maleFaceGenderNeutralMask = maleFaceGender;
    end
    if strcmp(Phase,'ConfidenceQuery')
    %rearranged = resultsCSV.rearranged(iNode);
    didSubjectEnterRearranged = resultsCSV.didSubjectEnterRearranged(iNode);
    response = resultsCSV.response(iNode);
    stimulus = resultsCSV.Face(iNode);
    [imageFileDir,imageFileName] = fileparts(stimulus);
    genderChar = imageFileName(6);
    if strcmp(genderChar,'F')
        maleGenderFace = 0;
    elseif strcmp(genderChar,'M')
        maleGenderFace = 1;
    else maleGenderFace = NaN;
    end
    trialStruct(iTrial).maleFaceGenderRecollection = ;
    trialStruct(iTrial).stimulusTarget = stimulus;
    trialStruct(iTrial).sliderResponse = response;
    trialStruct(iTrial).didSubjectEnterRearranged = didSubjectEnterRearranged;
    iTrial = iTrial+1;
    end
    end
end

