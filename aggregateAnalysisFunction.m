function [durationStruct] = aggregateAnalysisFunction(trialStruct)
%exact replica
confidenceAnalysis = 1;
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
    
    if confidenceAnalysis == 1
    confidence = mean([durTrials.ConfidenceResponse]);
    confIntervalForConfResponse = 1.96*sqrt((confidence*(1-confidence))/observations);
    durationStruct(iDuration).confIntForConfidence = confIntervalForConfResponse;
    durationStruct(iDuration).meanConfidence = confidence;
    end

    RecordedTimeCol =  ([durTrials.recordedTime])';
    pd = fitdist(RecordedTimeCol,'Normal');
    meanRecordedTime = pd.mu;
    cd = paramci(pd);
    confIntRecTime = cd(2)-meanRecordedTime;
    durationStruct(iDuration).meanRecordedTime = meanRecordedTime;
    durationStruct(iDuration).recordedConfInt = confIntRecTime;
    durationStruct(iDuration).recordedStd = std(pd);
    
    clear performance
    clear observations
end
end