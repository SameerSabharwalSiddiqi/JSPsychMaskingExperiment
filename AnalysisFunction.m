function [durationStruct,trialStruct,identifier] = AnalysisFunction(dataCSV)
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
confidenceAnalysis = 0;
if ~isempty(find(strcmp(resultsCSV.Phase,'QueryConfidence')))
    confidenceAnalysis = 1;
end
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
    if confidenceAnalysis == 1 %%don't assume that this data has queryconfidence field
    if strcmp(Phase,'QueryConfidence') && isequal(resultsCSV.iTrial(iNode),iTrial)
    characterResponse = resultsCSV.CharacterResponse(iNode);
    trialStruct(iTrial).ConfidenceResponse = str2double(cell2mat(characterResponse));
    end
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
    
    %Also calculate hit rate etc.
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
    
    %Ending of hit rate analysis
    
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