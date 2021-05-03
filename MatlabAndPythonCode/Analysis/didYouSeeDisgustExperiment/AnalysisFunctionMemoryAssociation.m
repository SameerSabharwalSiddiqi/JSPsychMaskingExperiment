function [trialStruct,calibrationStruct,identifier,PreCalibrationQStruct] = AnalysisFunctionMemoryAssocation(dataCSV)
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
iCalibrationTrial = 1;
clear trialStruct
clear durationStruct
clear durTrials
for iNode = 1:nNodes
    run_id = resultsCSV.run_id(iNode);
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
    if strcmp(Phase,'IntactOrRearranged')
    didSubjectEnterRearranged = resultsCSV.didSubjectEnterRearranged(iNode);
    isTargetRearranged = resultsCSV.rearranged(iNode);
    end
    if strcmp(Phase,'ConfidenceQuery')
    %rearranged = resultsCSV.rearranged(iNode);
    response = resultsCSV.response(iNode);
    stimulus = resultsCSV.Face(iNode);
    block = resultsCSV.Block(iNode);
    [imageFileDir,imageFileName] = fileparts(stimulus);
    genderChar = imageFileName(6);
    if strcmp(genderChar,'F')
        maleGenderFace = 0;
    elseif strcmp(genderChar,'M')
        maleGenderFace = 1;
    else maleGenderFace = NaN;
    end
    trialStruct(iTrial).maleFaceGenderRecollection = maleGenderFace;
    trialStruct(iTrial).stimulusTarget = stimulus;
    trialStruct(iTrial).sliderResponse = response;
    trialStruct(iTrial).didSubjectEnterRearranged = didSubjectEnterRearranged;
    trialStruct(iTrial).isTargetRearranged = isTargetRearranged;
    trialStruct(iTrial).runID = run_id;
    trialStruct(iTrial).block = block;
    iTrial = iTrial+1;
    end
    elseif strcmp(ExperimentPhase,'Calibration')
      if strcmp(Phase,'Cue')
          calibrationStruct(iCalibrationTrial).stimulusCue = resultsCSV.stimulus(iNode);
      elseif strcmp(Phase,'Query')
          DisgustEntry = resultsCSV.CharacterResponse(iNode);
          calibrationStruct(iCalibrationTrial).DisgustEntry = DisgustEntry;
          calibrationStruct(iCalibrationTrial).runID = run_id;
          iCalibrationTrial = iCalibrationTrial + 1;
      end
    end
    %%BUG IN 3/23/2020 version of code, wherein ExperimentPhase and Phase
    %%are reverse-labelled. When bug is fixed in next run, copy-and-paste
    %%the below lines of code into the if-loop for all "Test" trials
    if strcmp(Phase,'WriteInQuestion')
        PreCalibrationQStruct.writeInQuestion = resultsCSV.responses(iNode);
    elseif strcmp(Phase,'MultiSelectionQuestion')
        PreCalibrationQStruct.multiSelect = resultsCSV.responses(iNode);
    end
end

end

