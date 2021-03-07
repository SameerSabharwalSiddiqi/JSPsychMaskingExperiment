function [durationStruct] = aggregateAnalysisFunction(trialStruct,confidenceAnalysis)
%exact replica
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
    
    
    %Calculate d' from hit rate- false alarm rate
    for iTrial = 1:max(size(durTrials))
        if strcmp(durTrials(iTrial).CorrectResponse,'1')
            durTrials(iTrial).oneForDisgustTrial = 1;
        elseif strcmp(durTrials(iTrial).CorrectResponse,'0')
            durTrials(iTrial).oneForDisgustTrial = 0;
        end
    end
    durTable = struct2table(durTrials);
    disgustTable = durTable(durTable.oneForDisgustTrial==1,:);
    disgustStruct = table2struct(disgustTable);
    neutralTable = durTable(durTable.oneForDisgustTrial==0,:);
    neutralStruct = table2struct(neutralTable);
    hitRate = nanmean(disgustTable.Success);

    falseAlarmRate = 1- nanmean(neutralTable.Success);
    dPrime = hitRate - falseAlarmRate;
    durationStruct(iDuration).dPrime = dPrime;
    durationStruct(iDuration).falseAlarmRate = falseAlarmRate;
    durationStruct(iDuration).hitRate = hitRate;
    
        confIntervalHitRate = 1.96*sqrt((hitRate*(1-hitRate))/length(disgustStruct));
    durationStruct(iDuration).hitRateConfInt = confIntervalHitRate;
        confIntervalfalseAlarmRate = 1.96*sqrt((falseAlarmRate*(1-falseAlarmRate))/length(neutralStruct));
    durationStruct(iDuration).FalarmConfInt = confIntervalfalseAlarmRate;
   %Ending of false alarm/hit analysis 
    
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