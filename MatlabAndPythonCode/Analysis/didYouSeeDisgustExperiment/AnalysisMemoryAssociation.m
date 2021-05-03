clear all
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\Analysis')
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\Analysis\memoryAssociationUnblocked')
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
[trialStruct,calibrationStruct,identifier,PreCalibrationQStruct] = AnalysisFunctionMemoryAssociation(resultsCSV);
[trialStruct,combinationStruct] = distributionOfGenderPresentation(trialStruct);
barXlabels = cell(1,4);
for i = 1:length(combinationStruct)
    barXlabels{i} = combinationStruct(i).genderKey;
end

%calculate success
%0 == intact. 1 == rearranged
for iTrial = 1:length(trialStruct)
    rearrangedStim = trialStruct(iTrial).isTargetRearranged{1};
    subjectEntry = trialStruct(iTrial).didSubjectEnterRearranged{1};
 if strcmp(subjectEntry,'"')    
        success = NaN;
        FAisOne = NaN;
        CorrectHitIsOne = NaN;
 elseif strcmp(rearrangedStim,subjectEntry) %Match = success, either correct rejection or hit.
        success = 1;
     if strcmp(subjectEntry,'0')
                FAisOne = NaN; 
                CorrectHitIsOne = 1;
    elseif strcmp(subjectEntry,'1')
               FAisOne = 0;
               CorrectHitIsOne = NaN;
     end
 elseif strcmp(rearrangedStim,'0') %and subjectEntry==1
        success = 0;
        FAisOne = NaN;
        CorrectHitIsOne = 0;
 elseif strcmp(rearrangedStim,'1') %and subject entry ==0
        success = 0;
        FAisOne= 1;
        CorrectHitIsOne = NaN;
end
    trialStruct(iTrial).success = success;
    trialStruct(iTrial).FAisOne = FAisOne;
    trialStruct(iTrial).CorrectHitIsOne = CorrectHitIsOne;
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
        
        aggregateCalibrationTable = struct2table(calibrationStruct);
        for iRun = 1:nRuns
            %subplot analysis
            subTableIndices = find(aggregateTable.runID==iRun);
            subTable = aggregateTable(subTableIndices,:);
            subTableHolder(runCntr+1).table = subTable;
            subTableHolder(runCntr+1).runID = iRun;
            
            %Convert Field "slider Response to Numeric"
            sliderResponseHolder = nan(1,height(subTable));
            for iTrial = 1:height(subTable)
                sliderResponse = str2double(subTable(iTrial,:).sliderResponse{1});
                sliderResponseHolder(iTrial) = sliderResponse;
            end
            
            subTableIndicesCalibration = find(aggregateCalibrationTable.runID==iRun);
            subTableCalibration = aggregateCalibrationTable(subTableIndicesCalibration,:);
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
        correctHitRate = nanmean([subTable.CorrectHitIsOne]);
        correctRejectionRate = nanmean([subTable.FAisOne]);        
        successBar = bar([success propNullResponse correctHitRate correctRejectionRate]);
        ylabel('percentage')
        ylim([0 1.1])
        yticks([0:.1:1.1])
        grid on
        %yline(0.5,'r','Linewidth',2)
        hold on 
        if runCntr == 1 
        figure(3)
        %legend('Success%','Null%','Hit%','CorrectRejection%');
        else
        end
        
        if confidenceAnalysis == 1
        confidenceBar = errorbar([durationStruct.cueDuration],[durationStruct.meanConfidence],[durationStruct.confIntForConfidence],'r');
        confidenceBar.LineWidth = 2;
        if runCntr == 1
        end
        end
        

        
        figure(4)
        hold on
        subplot(1,5,runCntr)
        hist(sliderResponseHolder)
        title('Distribution of Confidence Response')
        
        figure(5) %for calibration
        hold on 
        if runCntr == 1
            calibrationResultHolder = nan(1);
        end
            subCalibrationArray = strcmp([subTableCalibration.DisgustEntry],'y');
            calibrationResultHolder(runCntr) = nanmean(subCalibrationArray);

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
         

        end
            figure(5)
            bar(calibrationResultHolder)
            xlabel('subject')
            ylabel('Did You See Disgust Face % (1=YES)')
            title('Affective Face Calibration')
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
        figure(5)
scatter([runStruct.RecordedStd],[runStruct.Performance])
xlabel('std of computer display time')
ylabel('mean success at longest cue duration')

figure(6)
scatter([runStruct.RecordedStd],[runStruct.TimeSpentOnVideo])
xlabel('time spent on tutorial video')
ylabel('mean success at longest cue duration')
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ANALYSIS FOR MULTIPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FILES%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iscell(file)==1 && analysisChoice==0 %%subplot analysis

for iCSV = 1:length(resultsCSVstruct)
        resultsCSV = resultsCSVstruct{iCSV};
        [trialStruct,calibrationStruct,identifier,PreCalibrationQStruct] = AnalysisFunctionMemoryAssociation(resultsCSV);
        
%First create struct parameter "DISGUST CUE" by parsing existing stimulus
%cue for word disgust.

        %Doing for trialStruct
        for iTrial = 1:length(trialStruct)
        trialStruct(iTrial).disgustCue = contains(trialStruct(iTrial).stimulusCue,'DIS.JPG');
        sliderResponse = str2double(trialStruct(iTrial).sliderResponse{1});
        trialStruct(iTrial).sliderResponse = sliderResponse;
        end
        %And finally do for the cliabrationstruct. Also convert
        %"DisgustEntry" field into num from cell
        disgustCalibrationRaster = strcmp([calibrationStruct.DisgustEntry],'y');
        
        for iCalibrationTrial = 1:length(calibrationStruct)
            calibrationStruct(iCalibrationTrial).disgustCue = contains(calibrationStruct(iCalibrationTrial).stimulusCue,'DIS.JPG');
            calibrationStruct(iCalibrationTrial).DisgustEntry = disgustCalibrationRaster(iCalibrationTrial);
        end

        %Quickly convert calibration raster from cell to num
         
        
        %Incorporate Hit and FA rate into trialstruct
        %calculate success
for iTrial = 1:length(trialStruct)
    rearrangedStim = trialStruct(iTrial).isTargetRearranged{1};
    subjectEntry = trialStruct(iTrial).didSubjectEnterRearranged{1};
 if strcmp(subjectEntry,'"')    
        success = NaN;
        FAisOne = NaN;
        CorrectHitIsOne = NaN;
 elseif strcmp(rearrangedStim,subjectEntry) %Match = success, either correct rejection or hit.
        success = 1;
     if strcmp(subjectEntry,'0')
                FAisOne = 0; %0 for correct rejection as intact
                CorrectHitIsOne = NaN;
    elseif strcmp(subjectEntry,'1')
               CorrectHitIsOne = 1; %1 for correct hit as rearranged
               FAisOne = NaN;
     end
 elseif strcmp(rearrangedStim,'0') %and subjectEntry==1
        success = 0;
        FAisOne = 1;
        CorrectHitIsOne = NaN;
 elseif strcmp(rearrangedStim,'1') %and subject entry ==0
        success = 0;
        FAisOne= NaN;
        CorrectHitIsOne = 0;
end
    trialStruct(iTrial).success = success;
    trialStruct(iTrial).FAisOne = FAisOne;
    trialStruct(iTrial).CorrectHitIsOne = CorrectHitIsOne;
    clear success
    clear category
end

%turn trial struct into table 
        runTable = struct2table(trialStruct);
        runTable.sliderResponseNum = nan(1,height(runTable))';
        sliderResponseHolder = nan(1,height(runTable));
        %calculate block-by-block hit and rejection rate
        nBlocks = max(runTable.block);
        blockHitRateHolder = nan(1,nBlocks);
        blockHitConfHolder = nan(1,nBlocks);
        blockFArateHolder = nan(1,nBlocks);
        blockFAconfHolder = nan(1,nBlocks);
        nanHolder = nan(1,nBlocks);
        %And holder for sdt measures. 
        blockDprimeHolder = nan(1,nBlocks);
        blockBiasHolder = nan(1,nBlocks);
        
        for iBlock = 1:nBlocks
            blockTable = runTable(runTable.block==iBlock,:);
            nIntactTrials = sum(~isnan(blockTable.FAisOne));
            nRearrangedTrials = sum(~isnan(blockTable.CorrectHitIsOne));
            FArate = nanmean(blockTable.FAisOne);
            hitRate = nanmean(blockTable.CorrectHitIsOne);
            nNans = nanmean(sum(isnan(blockTable.success))/(length(blockTable.success)));
            [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);

            
            blockHitRateHolder(iBlock) = hitRate;
            blockHitConfHolder(iBlock) = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
            
            blockFArateHolder(iBlock) = FArate;
            blockFAconfHolder(iBlock) = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
            
            nanHolder(iBlock) = nNans;
            
            blockDprimeHolder(iBlock) = dpri;
            blockBiasHolder(iBlock) = ccrit;
        end
        
        figure(1)
        subplot(1,length(resultsCSVstruct),iCSV) 
        hitByBlockGraph = errorbar([1:nBlocks],[blockHitRateHolder],[blockHitConfHolder]);
        hitByBlockGraph.LineWidth = 3;
        hold on
        FAbyBlockGraph = errorbar([1:nBlocks],[blockFArateHolder],[blockFAconfHolder]);
        FAbyBlockGraph.LineWidth = 3;
        legend('hit rate','FA rate','No Entry %')
        NaNLine = plot([1:nBlocks],[nanHolder]);
        NaNLine.LineWidth = 2;
        NaNLine.Color = 'k';
        xlabel('block')
        ylim([0 1])
            
        %Below: Block graph showing d' between blocks, subplot between
        %subjects
        figure(2) 
        subplot(1,length(resultsCSVstruct),iCSV) 
        bar(blockDprimeHolder)
        ylabel('d-prime')
        xlabel('block')
        
        %Below: Hit FA etc. analysis that aggregates blocks, between subjects
        figure(3)
        subplot(1,length(resultsCSVstruct),iCSV) 
        
        nIntactTrials = sum(~isnan(blockTable.FAisOne));
        nRearrangedTrials = sum(~isnan(blockTable.CorrectHitIsOne));
        FArate = nanmean(blockTable.FAisOne);
        hitRate = nanmean(blockTable.CorrectHitIsOne);
        nNans = nanmean(sum(isnan(blockTable.success))/(length(blockTable.success)));
        
        [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
        hitRateConf = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
        faRateConf = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
        
        allBlocksHR = errorbar(1,hitRate,hitRateConf);
        ylim([0 1])
        allBlocksHR.LineWidth = 2;
        allBlocksHR.Marker = '*';
        allBlocksHR.MarkerSize = 12;
        ylabel('Probability')
        hold on
        allBlocksFA = errorbar(1,FArate,faRateConf);
        ylim([0 1])
        allBlocksFA.LineWidth = 2;
        allBlocksFA.Marker = '*';
        allBlocksFA.MarkerSize = 12;
        legend('hit','FA')
        
        %%%%%%%%Hit Rate Analysis for CALIBRATIOn STRUCT%%%%%%%%%%%%%%%%%%%
        figure(4)
        subplot(1,length(resultsCSVstruct),iCSV) 

        calibrationTable = struct2table(calibrationStruct);
        disgustTableCalibration = calibrationTable(calibrationTable.disgustCue == 1,:);
        neutralTableCalibration = calibrationTable(calibrationTable.disgustCue == 0,:);
        
        hitRateDisgust = nanmean(disgustTableCalibration.DisgustEntry);
        nDisgustTrials = sum(~isnan(disgustTableCalibration.DisgustEntry));
        hitRateConfDisgust = 1.96*sqrt((hitRateDisgust*(1-hitRateDisgust))/nDisgustTrials);
                
        faRateNeutral = nanmean(neutralTableCalibration.DisgustEntry);
        nNeutralTrials = sum(~isnan(neutralTableCalibration.DisgustEntry));
        faRateConfNeutral = 1.96*sqrt((faRateNeutral*(1-faRateNeutral))/nNeutralTrials);
        
        hitRateDisgustPlot = errorbar(1,hitRateDisgust,hitRateConfDisgust);
        
        ylim([0 1])
        hitRateDisgustPlot.LineWidth = 2;
        hitRateDisgustPlot.Marker = '*';
        hitRateDisgustPlot.MarkerSize = 12;
                ylabel('P(SawDisgust)')

        
        hold on
        
        faRatePlot = errorbar(1,faRateNeutral,faRateConfNeutral);
        ylim([0 1])
        faRatePlot.LineWidth = 2;
        faRatePlot.Marker = '*';
        faRatePlot.MarkerSize = 12;
        
        legend('Hit Rate','FA Rate')

        %%% Final Analysis for blocks == d' for disgust/neutral cue trials,
        %%% across all blocks 
        
        figure(5)
        subplot(1,length(resultsCSVstruct),iCSV) 
        neutralTable = runTable(runTable.disgustCue==0,:);
        

        nIntactTrials = sum(~isnan(neutralTable.FAisOne));
        nRearrangedTrials = sum(~isnan(neutralTable.CorrectHitIsOne));
        FArate = nanmean(neutralTable.FAisOne);
        hitRate = nanmean(neutralTable.CorrectHitIsOne);
        nNans = nanmean(sum(isnan(neutralTable.success))/(length(neutralTable.success)));
        
        [dpriNeutral,ccritNeutral] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
        
        disgustTable = runTable(runTable.disgustCue==1,:);

        nIntactTrials = sum(~isnan(disgustTable.FAisOne));
        nRearrangedTrials = sum(~isnan(disgustTable.CorrectHitIsOne));
        FArate = nanmean(disgustTable.FAisOne);
        hitRate = nanmean(disgustTable.CorrectHitIsOne);
        nNans = nanmean(sum(isnan(disgustTable.success))/(length(disgustTable.success)));
        [dpriDisgust,ccritDisgust] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
        
        blockDprimeValues = [dpriNeutral,dpriDisgust];
        
        %Figure(8) - confidence to H and FA rate confidence curves 
        confBlocks = [0 33 66 100];
        
        %CONF blockHolder
        nConfBlocks = length(confBlocks)-1;
        nXconfMeans = nan(1,nConfBlocks);
        confblockHitRateHolder = nan(1,nConfBlocks);
        confblockHitConfHolder = nan(1,nConfBlocks);
        confblockFArateHolder = nan(1,nConfBlocks);
        confblockFAconfHolder = nan(1,nConfBlocks);
        confnanHolder = nan(1,nConfBlocks);
        confNObservations = nan(1,nConfBlocks);
        %And holder for sdt measures. 
        confblockDprimeHolder = nan(1,nConfBlocks);
        confblockBiasHolder = nan(1,nConfBlocks);
        for iConfBlock = 1:nConfBlocks
            lowBar = confBlocks(iConfBlock);
            hiBar = confBlocks(iConfBlock+1);
            nXconfMeans(iConfBlock) = mean(lowBar,hiBar);
            hiTable = runTable(runTable.sliderResponse>lowBar,:);
            confTable = hiTable(hiTable.sliderResponse<hiBar,:);
            
            
            nIntactTrials = sum(~isnan(confTable.FAisOne));
            nRearrangedTrials = sum(~isnan(confTable.CorrectHitIsOne));
            FArate = nanmean(confTable.FAisOne);
            hitRate = nanmean(confTable.CorrectHitIsOne);
            NanRate = nanmean(sum(isnan(confTable.success))/(length(confTable.success)));
            [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
            nObservations = height(confTable);

            
            confblockHitRateHolder(iConfBlock) = hitRate;
            confblockHitConfHolder(iConfBlock) = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
            
            confblockFArateHolder(iConfBlock) = FArate;
            confblockFAconfHolder(iConfBlock) = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
            
            confnanHolder(iConfBlock) = NanRate;
            confNObservations(iConfBlock) = nObservations;
            
            confblockDprimeHolder(iConfBlock) = dpri;
            blockBiasHolder(iConfBlock) = ccrit;
        end
        figure(8)
        hold on 
        %Top Plot: Confidence Prediction Accuracy (Hit Rate etc.)
        subplot(2,length(resultsCSVstruct),iCSV) 
        confhitByBlockGraph = errorbar([nXconfMeans],[confblockHitRateHolder],[confblockHitConfHolder]);
        confhitByBlockGraph.LineWidth = 3;
        hold on
        confFAbyBlockGraph = errorbar([nXconfMeans],[confblockFArateHolder],[confblockFAconfHolder]);
        confFAbyBlockGraph.LineWidth = 3;
        confNaNLine = plot([nXconfMeans],[confnanHolder]);
        confNaNLine.LineWidth = 2;
        confNaNLine.Color = 'k';
        xlabel('midpoint of Confidence Bin')
        ylim([0 1])
        if iCSV ==1
        legend('hit rate','FA rate','No Entry %','Location','Northeast')
        end
        ylabel('%')
        title(identifier) 
        
        %Bottom Plot: nObservationsPerBlock 
        subplot(2,length(resultsCSVstruct),iCSV+5) 
        bar([nXconfMeans],[confNObservations])
        ylabel('nObservations')
        xlabel('midpoint of Confidence Bin')
        ylim([0 60])
        title(identifier) 

        


        
        %Finally, loading up the trialStructHolder 
        trialStructHolder(iCSV).runTable = runTable;
        trialStructHolder(iCSV).calibrationStruct = calibrationStruct;
        trialStructHolder(iCSV).identifier = identifier;      
        trialStructHolder(iCSV).blockDprimeValues = blockDprimeValues; 
        trialStructHolder(iCSV).hitRateDisgust = hitRateDisgust;
        trialStructHolder(iCSV).recordedCueTime = nanmean([trialStruct.recordedCueTime]);
end
  
respontrialStrutHolder.preCalibrationQstruct = 

figure(6)
blockDprimeValues;
bar([1.0491,0.8344;1.3293,1.0768;  0.9191    0.9196  ;  2.4573    1.8326  ;  0.8375    1.1316])
legend('dPrime: Neutral Cue','dPrime: Disgust Cue')
xlabel('subject')
ylabel('dPrime')
title('dPrime for Neutral vs. Disgust Cue Conditions. Between Subjects.')

figure(7) 
bar([trialStructHolder.recordedCueTime])
xlabel('subject')
ylabel('Avg Cue Time')
title('Average ACTUAL cue time for each subject')

aggregateData = vertcat(trialStructHolder.runTable);
aggregateData = aggregateData(aggregateData.recordedCueTime<=33,:);
allNeutralTable = aggregateData(aggregateData.disgustCue==0,:);
allDisgustTable = aggregateData(aggregateData.disgustCue==1,:);
aggregateTableStruct(1).table = allNeutralTable;
aggregateTableStruct(2).table = allDisgustTable;
for i = 1:2
        aggTable = aggregateTableStruct(i).table;
        %Figure(10) - confidence to H and FA rate for ALL data, between
        %NEutral and DIsgust
        confBlocks = [0 33 66 100];
        
        %CONF blockHolder
        nConfBlocks = length(confBlocks)-1;
        nXconfMeans = nan(1,nConfBlocks);
        confblockHitRateHolder = nan(1,nConfBlocks);
        confblockHitConfHolder = nan(1,nConfBlocks);
        confblockFArateHolder = nan(1,nConfBlocks);
        confblockFAconfHolder = nan(1,nConfBlocks);
        confnanHolder = nan(1,nConfBlocks);
        confNObservations = nan(1,nConfBlocks);
        %And holder for sdt measures. 
        confblockDprimeHolder = nan(1,nConfBlocks);
        confblockBiasHolder = nan(1,nConfBlocks);
        for iConfBlock = 1:nConfBlocks
            lowBar = confBlocks(iConfBlock);
            hiBar = confBlocks(iConfBlock+1);
            nXconfMeans(iConfBlock) = mean(lowBar,hiBar);
            hiTable = aggTable(aggTable.sliderResponse>lowBar,:);
            confTable = hiTable(hiTable.sliderResponse<hiBar,:);
            
            
            nIntactTrials = sum(~isnan(confTable.FAisOne));
            nRearrangedTrials = sum(~isnan(confTable.CorrectHitIsOne));
            FArate = nanmean(confTable.FAisOne);
            hitRate = nanmean(confTable.CorrectHitIsOne);
            NanRate = nanmean(sum(isnan(confTable.success))/(length(confTable.success)));
            [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
            nObservations = height(confTable);

            
            confblockHitRateHolder(iConfBlock) = hitRate;
            confblockHitConfHolder(iConfBlock) = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
            
            confblockFArateHolder(iConfBlock) = FArate;
            confblockFAconfHolder(iConfBlock) = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
            
            confnanHolder(iConfBlock) = NanRate;
            confNObservations(iConfBlock) = nObservations;
            
            confblockDprimeHolder(iConfBlock) = dpri;
            blockBiasHolder(iConfBlock) = ccrit;
        end
        figure(10)
        hold on 
        %Top Plot: Confidence Prediction Accuracy (Hit Rate etc.)
        subplot(2,2,i) 
        confhitByBlockGraph = errorbar([nXconfMeans],[confblockHitRateHolder],[confblockHitConfHolder]);
        confhitByBlockGraph.LineWidth = 3;
        hold on
        confFAbyBlockGraph = errorbar([nXconfMeans],[confblockFArateHolder],[confblockFAconfHolder]);
        confFAbyBlockGraph.LineWidth = 3;
        confNaNLine = plot([nXconfMeans],[confnanHolder]);
        confNaNLine.LineWidth = 2;
        confNaNLine.Color = 'k';
        xlabel('midpoint of Confidence Bin')
        ylim([0 1])
        if iCSV ==1
        legend('hit rate','FA rate','No Entry %','Location','Northwest')
        end
        ylabel('%')
        if i == 1
        title('All Neutral Cue Trials. Recorded Cue TIme <= 33ms')
        legend('Hit Rate','FA Rate','Null Rate','Location','Northeast')
        elseif i == 2
        title('All Disgust Cue Trials. Recorded Cue Time <= 33ms')
        end
        
        %Bottom Plot: nObservationsPerBlock 
        subplot(2,2,i+2) 
        bar([nXconfMeans],[confNObservations])
        ylabel('nObservations')
        xlabel('midpoint of Confidence Bin')
        ylim([0 140])
end

    %analysis that aggregates blocks
    %subplot(1,length(resultsCSVstruct),iCSV) 

%     nIntactTrials = sum(~isnan(runTable.FAisOne));
%     nRearrangedTrials = sum(~isnan(runTable.CorrectHitIsOne));
%     FArate = nanmean(runTable.FAisOne);
%     hitRate = nanmean(runTable.CorrectHitIsOne);
%     nNans = nanmean(sum(isnan(runTable.success))/(length(blockTable.success)));
%     [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
%     hitRateConf = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
%     faRateConf = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
%     allBlocksHR = errorbar(1,hitRate,hitRateConf);
%     allBlocksHR.LineWidth = 2;
%     allBlocksFA = errorbar(1,FArate,faRateConf);
%     allBlocksFA.LineWidth = 2;
    
    %analysis that returns d' SPECIFICALLY for DISGUST vs NON-DISGUST
    %trials
    %Disgust Trials
    
    
    
    %analysis that aggregates subjects
    
    
    
elseif iscell(file)==1 && analysisChoice==1
end