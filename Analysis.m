clear resultsCSV
resultsCSV = readtable('sampleData/practiceRun2.csv');
nTrials = max(resultsCSV.iTrial);
nNodes = max(size(resultsCSV));
iTrial = 1;
clear trialStruct
for iNode = 1:nNodes
    Phase = resultsCSV.Phase(iNode);
    if strcmp(Phase, 'forwardMask') && isequal(resultsCSV.iTrial(iNode),iTrial)
    trialStruct(iTrial).CorrectResponse = resultsCSV.correctResponse(iNode);
    end
    if strcmp(Phase, 'Cue') && isequal(resultsCSV.iTrial(iNode),iTrial)
    trialStruct(iTrial).CueDuration = resultsCSV.StimulusDurationSetting(iNode);
    end
    if strcmp(Phase,'Query') && isequal(resultsCSV.iTrial(iNode),iTrial)
    trialStruct(iTrial).EnteredResponse = resultsCSV.CharacterResponse(iNode);
    if strcmp(trialStruct(iTrial).EnteredResponse,trialStruct(iTrial).CorrectResponse)
        trialStruct(iTrial).Success = 1;
    else 
        trialStruct(iTrial).Success = 0;
    end
    iTrial = iTrial+1;
    end
end

durations = unique([trialStruct.CueDuration]);
for iDuration = 1:length(durations)
    cueDuration = durations(iDuration);
    durationStruct(iDuration).cueDuration = cueDuration;
    indicesOfTrialsWithDur = find([trialStruct.CueDuration],cueDuration);
    durTrials = trialStruct(indicesOfTrialsWithDur);
    performance = mean([durTrials.Success]);
    durationStruct(iDuration).success = performance;
    observations = length(durTrials);
    confInterval = 1.96*sqrt((performance*(1-performance))/observations);
    durationStruct(iDuration).confInt = confInterval;
    clear performance
    clear observations
end

figure(1)
errorbar([durationStruct.cueDuration],[durationStruct.success],[durationStruct.confInt])
title('Success by Cue Duration')
xlabel('Cue Duration in ms')
ylabel('mean success with Wald-Type Conf Interval')