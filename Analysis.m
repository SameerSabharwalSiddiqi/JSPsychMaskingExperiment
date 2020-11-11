clear resultsCSV
resultsCSV = readtable('sampleData/practiceRun4');
nTrials = max(resultsCSV.iTrial);
nNodes = max(size(resultsCSV));
iTrial = 1;
clear trialStruct
clear durationStruct
clear durTrials
for iNode = 1:nNodes
    Phase = resultsCSV.Phase(iNode);
    if strcmp(Phase, 'forwardMask') && isequal(resultsCSV.iTrial(iNode),iTrial)
    trialStruct(iTrial).CorrectResponse = resultsCSV.correctResponse(iNode);
    end
    if strcmp(Phase, 'Cue') && isequal(resultsCSV.iTrial(iNode),iTrial)
    trialStruct(iTrial).CueDuration = resultsCSV.StimulusDurationSetting(iNode);
    lastTimePoint = resultsCSV.time_elapsed(iNode-1); %time elapse before onset of cue time
    crntTimePoint = resultsCSV.time_elapsed(iNode); 
    recordedTime = crntTimePoint-lastTimePoint;
    trialStruct(iTrial).recordedTime = recordedTime;
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
    indicesOfTrialsWithDur = find([trialStruct.CueDuration]==cueDuration);
    durTrials = trialStruct(indicesOfTrialsWithDur);
    performance = mean([durTrials.Success]);
    durationStruct(iDuration).success = performance;
    observations = length(durTrials);
    confInterval = 1.96*sqrt((performance*(1-performance))/observations);
    durationStruct(iDuration).confInt = confInterval;
    
    RecordedTimeCol =  ([durTrials.recordedTime])';
    pd = fitdist(RecordedTimeCol,'Normal');
    meanRecordedTime = pd.mu;
    cd = paramci(pd);
    confIntRecTime = cd(2)-meanRecordedTime;
    durationStruct(iDuration).meanRecordedTime = meanRecordedTime;
    durationStruct(iDuration).recordedConfInt = confIntRecTime;
    
    clear performance
    clear observations
end

figure(1)
successBar = errorbar([durationStruct.cueDuration],[durationStruct.success],[durationStruct.confInt]);
successBar.LineWidth = 2;
title('Success by Cue Duration')
xlabel('Cue Duration in ms')
ylabel('mean success with Wald-Type Conf Interval')
ylim([0 1.1])
yticks([0:.1:1.1])
grid on
xlim([0,max([durationStruct.cueDuration])+50])

figure(2)
timeCalibrationBar = errorbar([durationStruct.cueDuration],[durationStruct.meanRecordedTime],[durationStruct.recordedConfInt]);
title('Cue Time: Time Set vs. Actual Time Elapsed According to System')
xlabel('Set Duration in ms')
ylabel('Actual Duration in ms')
timeCalibrationBar.LineWidth = 2;


resultsCSV.time_elapsed(end)-resultsCSV.time_elapsed(1);
