clear all
%File selection
confidenceAnalysis = 0;
[file,path] = uigetfile('*.csv',...
   'Select One or More Excel Files', ...
   'MultiSelect', 'on');
if iscell(file) == 0 %%not cell array --> single string that corresponds with single file
    resultsCSV = fullfile(path,file);
    aggregateQ = input('does this CSV have data from multiple runs? Select 0 if no 1 if yes');
else %%cell array corresponds with multiple files/multi-selection
    analysisChoice =input('Select 0 for individual analyses of files (subplots), or 1 for aggregate analysis\n');
    if analysisChoice == 0
        for iCSV = 1:length(file)
        resultsCSVstruct(iCSV) = fullfile(path,file(iCSV));
        end
    elseif analysisChoice == 1
        resultsCSV = concCSVtables([file,path]); %for aggregate analysis, conc. into one giant table
        %%SINCE cognition.run seems actually to output aggregate into
        %%single CSV file, will NOT bother finishing this code for now 
    end

end


if iscell(file) == 0
%Analysis for single CSV file
[trialStruct,identifier] = AnalysisFunctionMemoryAssociation(resultsCSV);
[trialStruct,combinationStruct] = distributionOfGenderPresentation(trialStruct);
barXlabels = cell(1,4);
for i = 1:length(combinationStruct)
    barXlabels{i} = combinationStruct(i).genderKey;
end

%calculate success
for iTrial = 1:length(trialStruct)
    rearrangedStim = trialStruct(iTrial).isTargetRearranged{1};
    subjectEntry = trialStruct(iTrial).didSubjectEnterRearranged{1};
 if strcmp(subjectEntry,'"')    
        success = NaN;
        FAorCorrectRejection = NaN;
        MissOrCorrectHit = NaN;
 elseif strcmp(rearrangedStim,subjectEntry) 
        success = 1;
 if strcmp(subjectEntry,'0')
            FAorCorrectRejection = 1; %0 for correct rejection as intact
            MissOrCorrectHit = NaN;
elseif strcmp(subjectEntry,'1')
           MissOrCorrectHit = 1; %1 for correct hit as rearranged
            FAorCorrectRejection = NaN;
 end
 elseif strcmp(rearrangedStim,'0') 
        success = 0;
        FAorCorrectRejection = NaN;
        MissOrCorrectHit = 0;
 elseif strcmp(rearrangedStim,'1')
        success = 0;
        FAorCorrectRejection= 0;
        MissOrCorrectHit = NaN;
end
    trialStruct(iTrial).success = success;
    trialStruct(iTrial).FAorCorrectRejection = FAorCorrectRejection;
    trialStruct(iTrial).MissOrCorrectHit = MissOrCorrectHit;
    clear success
    clear category
end

if aggregateQ == 0
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
hold on 
confidenceBar = errorbar([durationStruct.cueDuration],[durationStruct.meanConfidence],[durationStruct.confIntForConfidence]);
legend('performance on 2AFC','confidence (binary)')

figure(2)
timeCalibrationBar = errorbar([durationStruct.cueDuration],[durationStruct.meanRecordedTime],[durationStruct.recordedConfInt]);
title('Cue Time: Time Set vs. Actual Time Elapsed According to System')
xlabel('Set Duration in ms')
ylabel('Actual Duration in ms')
timeCalibrationBar.LineWidth = 2;


elseif aggregateQ ==1
        aggregateTable = struct2table(trialStruct);
        nRuns = max(aggregateTable.runID);
        runCntr = 0;
        for iRun = 1:nRuns
            %subplot analysis
            subTableIndices = find(aggregateTable.runID==iRun);
            subTable = aggregateTable(subTableIndices,:);
            if ~isempty(subTable)
            %[durationStruct,trialStruct,identifier] = AnalysisFunction(subTable);
            runCntr = runCntr +1;
            
            %results_figure
        figure(3)
        hold on
        subplot(1,5,runCntr) %SUBPLOT - currently set for 5 runs!
        %metric 1 - find percentage of responses that were NaN
        nanMat = find(isnan([subTable.success])); 
        onesMat = ones(length(nanMat),1);
        nanCntr = sum(onesMat);
        entryCntr = height(subTable) - nanCntr;
        propNullResponse = nanCntr/(entryCntr+nanCntr);
        %metric 2 - success
        success = nanmean([subTable.success]);
        correctHitRate = nanmean([subTable.MissOrCorrectHit]);
        correctRejectionRate = nanmean([subTable.FAorCorrectRejection]);        
        successBar = bar([success propNullResponse correctHitRate correctRejectionRate]);
        ylabel('percentage')
        ylim([0 1.1])
        yticks([0:.1:1.1])
        grid on
        %yline(0.5,'r','Linewidth',2)
        hold on 
        
        if confidenceAnalysis == 1
        confidenceBar = errorbar([durationStruct.cueDuration],[durationStruct.meanConfidence],[durationStruct.confIntForConfidence],'r');
        confidenceBar.LineWidth = 2;
        if runCntr == 1
        end
        end
        end


            %computer_synchrony
%                         figure(4)
%             hold on
%             subplot(2,5,runCntr) %SUBPLOT - currently set for 10 runs!
%             timeCalibrationBar = errorbar([durationStruct.cueDuration],[durationStruct.meanRecordedTime],[durationStruct.recordedConfInt]);
%                     title(identifier)
%                     xlabel('set cue time')
%                     ylabel('actual cue time')
%             %finally, collect data for comparing performance on highest
%             %duration with other metrices to gauge subject motivation
%             runStruct(iRun).Performance = durationStruct(end).success;
%             runStruct(iRun).RecordedStd = mean([durationStruct.recordedStd]);
%             runStruct(iRun).TimeSpentOnVideo = subTable.time_elapsed(3)-subTable.time_elapsed(2);
%             runStruct(iRun).subTableStruct = trialStruct;
            
            %Hit/FA rate graph
%             figure(22)
%             subplot(2,5,runCntr)
%             
%         hitRateBar = errorbar([durationStruct.cueDuration],[durationStruct.hitRate],[durationStruct.hitRateConfInt]);
%         hitRateBar.LineWidth = 2;
%         title(identifier)
%         xlabel('Cue Duration in ms')
%         ylabel('Probability')
%         ylim([0 1.1])
%         yticks([0:.1:1.1])
%         grid on
%         xlim([0,max([durationStruct.cueDuration])+50])
%         hold on
%         faRateBar = errorbar([durationStruct.cueDuration],[durationStruct.falseAlarmRate],[durationStruct.FalarmConfInt]);
%         faRateBar.LineWidth = 2;
         
            if runCntr == 1 
            figure(3)
            legend('Success%','Null%','Hit%','CorrectRejection%');
            else
            end
            end
end


    %aggregate table
    figure(1)
    aggStruct = horzcat(runStruct.subTableStruct);
    durationStruct = aggregateAnalysisFunction(aggStruct,confidenceAnalysis);
        successBar = errorbar([durationStruct.cueDuration],[durationStruct.success],[durationStruct.confInt]);
        successBar.LineWidth = 2;
        title('aggregate data')
        xlabel('Cue Duration in ms')
        ylabel('success')
        ylim([0 1.1])
        yticks([0:.1:1.1])
        grid on
        xlim([0,max([durationStruct.cueDuration])+50])
        %yline(0.5,'r','Linewidth',2)
        hold on 
     if confidenceAnalysis == 1
     confidenceBar = errorbar([durationStruct.cueDuration],[durationStruct.meanConfidence],[durationStruct.confIntForConfidence],'r');
     confidenceBar.LineWidth = 2;
     legend('Performance','Confidence','Location','southeast');
     end
        
     figure(2)
     AgghitRateBar = errorbar([durationStruct.cueDuration],[durationStruct.hitRate],[durationStruct.hitRateConfInt]);
     AgghitRateBar.LineWidth = 2;
     hold on 
     AggfaRateBar = errorbar([durationStruct.cueDuration],[durationStruct.falseAlarmRate],[durationStruct.FalarmConfInt]);
     AggfaRateBar.LineWidth = 2;
     legend('hit rate','false alarm rate')
     
    
             
    %%bias analysis 
    for iTrial = 1:max(size(aggStruct))
        if strcmp(aggStruct(iTrial).CorrectResponse,'1')
            aggStruct(iTrial).oneForDisgustTrial = 1;
        elseif strcmp(aggStruct(iTrial).CorrectResponse,'0')
            aggStruct(iTrial).oneForDisgustTrial = 0;
        end
    end
    
    %Disgust subplot
    aggTable = struct2table(aggStruct);
    disgustTable = aggTable(aggTable.oneForDisgustTrial==1,:);
    disgustStruct = table2struct(disgustTable);
    neutralTable = aggTable(aggTable.oneForDisgustTrial==0,:);
    neutralStruct = table2struct(neutralTable);
    figure(10)
    subplot(1,2,1)
    durationStructdisgust = aggregateAnalysisFunction(disgustStruct,confidenceAnalysis);
    successBarDisgust = errorbar([durationStructdisgust.cueDuration],[durationStructdisgust.success],[durationStructdisgust.confInt]);
    successBarDisgust.LineWidth = 2;
    successBarDisgust.Color = 'r';
    if confidenceAnalysis == 0
        legend('disgustTrials Performance')
    end

    hold on 
    if confidenceAnalysis == 1
             legend('disgustTrials Performance','disgustTrials Confidence');

    confidenceBarDisgust = errorbar([durationStructdisgust.cueDuration],[durationStructdisgust.meanConfidence],[durationStructdisgust.confIntForConfidence]);
    confidenceBarDisgust.LineWidth = 2;
    confidenceBarDisgust.Color = 'r';
    confidenceBarDisgust.LineStyle = ':';  
    end
    
    %Neutral Subplot
    subplot(1,2,2)
    hold on 
    durationStructNeutral = aggregateAnalysisFunction(neutralStruct,confidenceAnalysis);
    successBarNeutral = errorbar([durationStructNeutral.cueDuration],[durationStructNeutral.success],[durationStructNeutral.confInt]);
    successBarNeutral.LineWidth = 2;
    successBarNeutral.Color = 'b';
    if confidenceAnalysis == 0
    legend('Neutral Trials Performance')
    end
    if confidenceAnalysis == 1
    confidenceBarNeutral = errorbar([durationStructNeutral.cueDuration],[durationStructNeutral.meanConfidence],[durationStructNeutral.confIntForConfidence]);
    confidenceBarNeutral.LineWidth = 2;
    confidenceBarNeutral.Color = 'b';
    confidenceBarNeutral.LineStyle = ':'; 
    end
    legend('neutralTrials Performance','neutralTrials Confidence');
        xlabel('Cue Duration in ms')
        ylim([0 1.1])
        yticks([0:.1:1.1])
    end
figure(5)
scatter([runStruct.RecordedStd],[runStruct.Performance])
xlabel('std of computer display time')
ylabel('mean success at longest cue duration')

figure(6)
scatter([runStruct.RecordedStd],[runStruct.TimeSpentOnVideo])
xlabel('time spent on tutorial video')
ylabel('mean success at longest cue duration')


if iscell(file)==1 && analysisChoice==0 %%subplot analysis
    for iCSV = 1:length(resultsCSVstruct)
        resultsCSV = resultsCSVstruct{iCSV};
        [durationStruct,trialStruct,identifier] = AnalysisFunction(resultsCSV);
        %plot
        subplot(1,length(resultsCSVstruct),iCSV)
        successBar = errorbar([durationStruct.cueDuration],[durationStruct.success],[durationStruct.confInt]);
        successBar.LineWidth = 2;
        title(identifier)
        xlabel('Cue Duration in ms')
        ylabel('mean success with Wald-Type Conf Interval')
        ylim([0 1.1])
        yticks([0:.1:1.1])
        grid on
        xlim([0,max([durationStruct.cueDuration])+50])
    end
elseif iscell(file)==1 && analysisChoice==1
end