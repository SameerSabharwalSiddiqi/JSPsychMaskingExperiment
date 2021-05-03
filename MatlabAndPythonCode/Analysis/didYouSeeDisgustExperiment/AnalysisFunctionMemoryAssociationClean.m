%%%WARNING/REMINDER MANUAL "SEMI-COLONING" REQUIRED FOR Neutral vs. Disgust
%%%DPRIME GRAPH, figure(6)
%%%END

clear all
plotFigures = 0;
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\Analysis')
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\Analysis\memoryAssociationUnblocked')
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\chuaLabCode')
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ANALYSIS FOR MULTIPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FILES%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iscell(file)==1 && analysisChoice==0 %%subplot analysis

for iCSV = 1:length(resultsCSVstruct)
        resultsCSV = resultsCSVstruct{iCSV};
        [trialStruct,calibrationStruct,identifier,PreCalibrationQStruct] = AnalysisFunctionMemoryAssociation(resultsCSV);
        runID = trialStruct.runID;
        
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
    subjectEntry = trialStruct(iTrial).didSubjectEnterRearranged{1};  % 0 = intact, 1 = rearranged
 if strcmp(subjectEntry,'"')    
        success = NaN;
        FAisOne = NaN;
        CorrectHitIsOne = NaN;
 elseif strcmp(rearrangedStim,subjectEntry) %Match = success, either correct rejection or hit.
        success = 1;
     if strcmp(subjectEntry,'0') %INTACT/HIT
               FAisOne = NaN; 
               CorrectHitIsOne = 1;
    elseif strcmp(subjectEntry,'1')
               CorrectHitIsOne = NaN; %1 for correct hit as rearranged
               FAisOne = 0; %0 for correct rejection (i.e., rejecting item is in memory)
     end
 elseif strcmp(rearrangedStim,'0') %and subjectEntry==1. %MISS
        success = 0; 
        FAisOne = NaN;
        CorrectHitIsOne = 0;
 elseif strcmp(rearrangedStim,'1') %and subject entry ==0, %FA
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
        
        if plotFigures == 1
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
        end
        %Below: Hit FA etc. analysis that aggregates blocks, between subjects

        nIntactTrials = sum(~isnan(runTable.FAisOne));
        nRearrangedTrials = sum(~isnan(runTable.CorrectHitIsOne));
        FArate = nanmean(runTable.FAisOne);
        hitRate = nanmean(runTable.CorrectHitIsOne);
        nNans = nanmean(sum(isnan(runTable.success))/(length(runTable.success)));
        
        [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
        hitRateConf = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
        faRateConf = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
        
        if plotFigures ==1
        
                figure(3)
        subplot(1,length(resultsCSVstruct),iCSV) 
        allBlocksHR = errorbar(1,hitRate,hitRateConf);
        title(runID)
        xlabel(runID)
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
        end
        
        %%%%%%%%Hit Rate Analysis for CALIBRATIOn STRUCT%%%%%%%%%%%%%%%%%%%
        calibrationTable = struct2table(calibrationStruct);
        disgustTableCalibration = calibrationTable(calibrationTable.disgustCue == 1,:);
        neutralTableCalibration = calibrationTable(calibrationTable.disgustCue == 0,:);
        
        hitRateDisgust = nanmean(disgustTableCalibration.DisgustEntry);
        nDisgustTrials = sum(~isnan(disgustTableCalibration.DisgustEntry));
        hitRateConfDisgust = 1.96*sqrt((hitRateDisgust*(1-hitRateDisgust))/nDisgustTrials);
                
        faRateNeutral = nanmean(neutralTableCalibration.DisgustEntry);
        nNeutralTrials = sum(~isnan(neutralTableCalibration.DisgustEntry));
        faRateConfNeutral = 1.96*sqrt((faRateNeutral*(1-faRateNeutral))/nNeutralTrials);
        
                if plotFigures ==1

        figure(4)
        subplot(1,length(resultsCSVstruct),iCSV) 

        
        
        hitRateDisgustPlot = errorbar(1,hitRateDisgust,hitRateConfDisgust);
        
        ylim([0 1])
        hitRateDisgustPlot.LineWidth = 2;
        hitRateDisgustPlot.Marker = '*';
        hitRateDisgustPlot.MarkerSize = 12;
                ylabel('P(SawDisgust)')
                title(runID)
                xlabel(runID)
        hold on
        
        faRatePlot = errorbar(1,faRateNeutral,faRateConfNeutral);
        ylim([0 1])
        faRatePlot.LineWidth = 2;
        faRatePlot.Marker = '*';
        faRatePlot.MarkerSize = 12;
        
        legend('Hit Rate','FA Rate')
                end

        %%% Final Analysis for blocks == d' for disgust/neutral cue trials,
        %%% across all blocks 
        
        runTableHit = runTable(runTable.CorrectHitIsOne==1,:);
        meanHit = nanmean(runTableHit.sliderResponse);
        stdHit = nanstd(runTableHit.sliderResponse);
        
        
        runTableFA = runTable(runTable.FAisOne==1,:);
        meanFA = nanmean(runTableFA.sliderResponse);
        stdFA = nanstd(runTableFA.sliderResponse);
        
        nIntactTrials = sum(~isnan(runTable.FAisOne));
        nRearrangedTrials = sum(~isnan(runTable.CorrectHitIsOne));
        hitRate = nanmean(runTable.CorrectHitIsOne);
        FArate = nanmean(runTable.FAisOne);
        [dpri,ccrit] = dprime(hitRate,FArate,nIntactTrials,nRearrangedTrials);
        
        
        neutralTable = runTable(runTable.disgustCue==0,:);
        nIntactTrials = sum(~isnan(neutralTable.FAisOne));
        nRearrangedTrials = sum(~isnan(neutralTable.CorrectHitIsOne));
        FArate = nanmean(neutralTable.FAisOne);
        hitRate = nanmean(neutralTable.CorrectHitIsOne);
        nNans = nanmean(sum(isnan(neutralTable.success))/(length(neutralTable.success)));
        
        %These parameters are for E's request to calculate average
        %confidence for expression-dependent FA and Hit trials. 
        neutralHitTable = neutralTable(neutralTable.CorrectHitIsOne==1,:);
        meanNeutralHit = nanmean(neutralHitTable.sliderResponse);
        stdNeutralHit = nanstd(neutralHitTable.sliderResponse);
        
        neutralFATable = neutralTable(neutralTable.FAisOne==1,:);
        meanNeutralFA = nanmean(neutralFATable.sliderResponse);
        stdNeutralFA = nanstd(neutralFATable.sliderResponse);
        
        
        [dpriNeutral,ccritNeutral] = dprime(hitRate,FArate,nIntactTrials,nRearrangedTrials);
        
        disgustTable = runTable(runTable.disgustCue==1,:);

        nIntactTrials = sum(~isnan(disgustTable.FAisOne));
        nRearrangedTrials = sum(~isnan(disgustTable.CorrectHitIsOne));
        FArate = nanmean(disgustTable.FAisOne);
        hitRate = nanmean(disgustTable.CorrectHitIsOne);
        nNans = nanmean(sum(isnan(disgustTable.success))/(length(disgustTable.success)));
        [dpriDisgust,ccritDisgust] = dprime(hitRate,FArate,nIntactTrials,nRearrangedTrials);
        
        %These parameters are for E's request to calculate average
        %confidence for expression-dependent FA and Hit trials. 
        disgustHitTable = disgustTable(disgustTable.CorrectHitIsOne==1,:);
        meanDisgustHit = nanmean(disgustHitTable.sliderResponse);
        stdDisgustHit = nanmean(disgustHitTable.sliderResponse);
        
        disgustFATable = disgustTable(disgustTable.FAisOne==1,:);
        meanDisgustFA = nanmean(disgustFATable.sliderResponse);
        stdDisgustFA = nanmean(disgustFATable.sliderResponse);
        
        subjectDprimeValues = [dpriNeutral,dpriDisgust];
        subjectBias = [ccritNeutral,ccritDisgust];
        
        if plotFigures ==1

        figure(5)
        subplot(1,length(resultsCSVstruct),iCSV) 
        barwitherr([stdNeutralHit,stdNeutralFA,stdDisgustHit,stdDisgustFA],[meanNeutralHit,meanNeutralFA,meanDisgustHit,meanDisgustFA])
        set(gca,'XTickLabel',{'NH','NFA','DH','DFA'})
        ylabel('Confidence/Slider-Response')
        title('Confidence Statistics Across Subjects,Expressions, and Hit/FA Trial')
        
        figure(24)
        subplot(1,length(resultsCSVstruct),iCSV)
        barwitherr([stdHit,stdFA],[meanHit,meanFA]);
        set(gca,'XTickLabel',{'Hit','FA'})
        ylabel('Confidence/Slider-Response')
        title('Confidence Statistics Across Subjects and Hit/FA Trial')

        end
        
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
        
        if plotFigures ==1

        figure(8)
        hold on 
        %Top Plot: Confidence Prediction Accuracy (Hit Rate etc.)
        subplot(1,length(resultsCSVstruct),iCSV) 
        confhitByBlockGraph = errorbar([nXconfMeans],[confblockHitRateHolder],[confblockHitConfHolder]);
        confhitByBlockGraph.LineWidth = 3;
        hold on
        confFAbyBlockGraph = errorbar([nXconfMeans],[confblockFArateHolder],[confblockFAconfHolder]);
        confFAbyBlockGraph.LineWidth = 3;
        confNaNLine = plot([nXconfMeans],[confnanHolder]);
        confNaNLine.LineWidth = 2;
        confNaNLine.Color = 'k';
        xlabel(runID)
        ylim([0 1])
        if iCSV ==1
        legend('hit rate','FA rate','No Entry %','Location','Northeast')
        end
        ylabel('%')
        title(identifier) 
        
        figure(81)
        %Bottom Plot: nObservationsPerBlock 
        subplot(1,length(resultsCSVstruct),iCSV) 
        bar([nXconfMeans],[confNObservations])
        ylabel('nObservations')
        xlabel(runID)
        ylim([0 60])
        title(identifier) 
        end

        
        %Finally, loading up the trialStructHolder 
        trialStructHolder(iCSV).runTable = runTable;
        trialStructHolder(iCSV).runID = runID;
        trialStructHolder(iCSV).calibrationStruct = calibrationStruct;
        trialStructHolder(iCSV).identifier = identifier;      
        trialStructHolder(iCSV).DprimeNeutralDisgust = subjectDprimeValues; %[Neutral Disgust]
        trialStructHolder(iCSV).biasNeutralDisgust = subjectBias; %[Neutral Disgust]
        trialStructHolder(iCSV).hitRateDisgust = hitRateDisgust;
        trialStructHolder(iCSV).recordedCueTime = nanmean([trialStruct.recordedCueTime]);
        trialStructHolder(iCSV).dPriAndccrit = [dpri ccrit];
        PreCalibrationQHolder(iCSV).writeInQuestion = PreCalibrationQStruct.writeInQuestion;
        PreCalibrationQHolder(iCSV).multiselect = PreCalibrationQStruct.multiSelect;
end
  questionTable = struct2table(PreCalibrationQHolder);


  
   if plotFigures ==1

figure(6)
subjectDprimeValues;
subplot(1,2,1)
bar([1.3856,    0.2722  ;  0.1937 ,   0.9952  ;  2.7242,    1.4736  ;  0.7892   , 0.6709  ;  2.2173    1.1430])
legend('dPrime: Neutral Cue','dPrime: Disgust Cue')
xlabel('subject')
ylabel('dPrime')
title('dPrime for Neutral vs. Disgust Cue Conditions. Between Subjects.')
subplot(1,2,2)
bar([0.0435 ,  -0.0981   ; 0.4691  ,  0.2940   ; 0.2311  , -0.0623  ;  0.0361  ,  0.0257 ;  -0.2964  ,  0.1648])
title('THIS FIGURE DOES NOT UPDATE AUTOMATICALLY. Bias (ccrit) between Neutral and Disgust')
xlabel('subject')
ylabel('ccrit')

figure(7) 
bar([trialStructHolder.recordedCueTime])
xlabel('subject')
ylabel('Avg Cue Time')
title('Average ACTUAL cue time for each subject')
   end

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
          if plotFigures ==1

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
        title('All Neutral Cue Trials. Recorded Cue TIme')
        legend('Hit Rate','FA Rate','Null Rate','Location','Northeast')
        elseif i == 2
        title('All Disgust Cue Trials. Recorded Cue Time')
        end
        
        %Bottom Plot: nObservationsPerBlock 
        subplot(2,2,i+2) 
        bar([nXconfMeans],[confNObservations])
        ylabel('nObservations')
        xlabel('midpoint of Confidence Bin')
        ylim([0 1000])
          end
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
 if plotFigures ==1

    figure(29)
    allNeutralTable = aggregateData(aggregateData.disgustCue==0,:);
        neutralHitTable = allNeutralTable(allNeutralTable.CorrectHitIsOne==1,:);
        meanNeutralHit = nanmean(neutralHitTable.sliderResponse);
        stdNeutralHit = nanstd(neutralHitTable.sliderResponse);
        
        neutralFATable = allNeutralTable(allNeutralTable.FAisOne==1,:);
        meanNeutralFA = nanmean(neutralFATable.sliderResponse);
        stdNeutralFA = nanstd(neutralFATable.sliderResponse);
        
          successVector = allNeutralTable.success;
          confidenceVector = allNeutralTable.sliderResponse;
          trialsToRemove1 = find(isnan(successVector));
          trialsToRemove2 = find(isnan(confidenceVector));
          trialsToRemove = union(trialsToRemove1,trialsToRemove2);
          successVector(trialsToRemove) = [];
          confidenceVector(trialsToRemove) = [];
          dSubANeutral = sdtMeta(successVector,confidenceVector,100,6);
          
          nRearrangedTrials = sum(~isnan(allNeutralTable.FAisOne));
          nIntactTrials = sum(~isnan(allNeutralTable.CorrectHitIsOne));
          FArate = nanmean(allNeutralTable.FAisOne);
          hitRate = nanmean(allNeutralTable.CorrectHitIsOne);
        [dpriAllNeutral,ccritAllNeutral] = dprime(hitRate,FArate,nIntactTrials,nRearrangedTrials);
          
        allDisgustTable = aggregateData(aggregateData.disgustCue==1,:);
        disgustHitTable = allDisgustTable(allDisgustTable.CorrectHitIsOne==1,:);
        meanDisgustHit = nanmean(disgustHitTable.sliderResponse);
        stdDisgustHit = nanmean(disgustHitTable.sliderResponse);
        
        successVector = allDisgustTable.success;
        confidenceVector = allDisgustTable.sliderResponse;
        trialsToRemove1 = find(isnan(successVector));
        trialsToRemove2 = find(isnan(confidenceVector));
        trialsToRemove = union(trialsToRemove1,trialsToRemove2);
        successVector(trialsToRemove) = [];
        confidenceVector(trialsToRemove) = [];
        dsubAdisgust = sdtMeta(successVector,confidenceVector,100,6);
          
        nRearrangedTrials = sum(~isnan(allDisgustTable.FAisOne));
        nIntactTrials = sum(~isnan(allDisgustTable.CorrectHitIsOne));
        FArate = nanmean(allDisgustTable.FAisOne);
        hitRate = nanmean(allDisgustTable.CorrectHitIsOne);
        [dpriAllDisgust,ccritAllDisgust] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
          
           
        disgustFATable = allDisgustTable(allDisgustTable.FAisOne==1,:);
        meanDisgustFA = nanmean(disgustFATable.sliderResponse);
        stdDisgustFA = nanmean(disgustFATable.sliderResponse);
        

        barwitherr([stdNeutralHit,stdNeutralFA,stdDisgustHit,stdDisgustFA],[meanNeutralHit,meanNeutralFA,meanDisgustHit,meanDisgustFA])
        set(gca,'XTickLabel',{'NH','NFA','DH','DFA'})
        ylabel('Confidence/Slider-Response')
        title('Confidence Statistics Across Expression and Hit/FA Trial')
 
 figure(37)
 subplot(1,3,1)
 X = categorical({'Neutral','Disgust'});

 bar(X,[dpriAllNeutral dpriAllDisgust;])
 title('dPrime')
 subplot(1,3,2)
 bar(X,[ccritAllNeutral ccritAllDisgust])
  title('criterion')

 subplot(1,3,3)
 bar(X,[dSubANeutral dsubAdisgust])
 title('dSubA')
 end
 
 %get Da and ROC under curve values from Chua Lab Code
 addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\chuaLabCode');
 nRuns = length(trialStructHolder);
 dSubArray = nan(1,length(trialStructHolder));
 maxCntr = nan(1,length(trialStructHolder));
 meanConfHitArray = nan(1,length(trialStructHolder));
 meanConfMissArray = nan(1,length(trialStructHolder));
 meanConfFaArray = nan(1,length(trialStructHolder));
 meanConfCRArray = nan(1,length(trialStructHolder));
 
 dprimeArrayNeutral = nan(1,length(trialStructHolder));
 dprimeArrayDisgust = nan(1,length(trialStructHolder));
 ccritArrayNeutral = nan(1,length(trialStructHolder));
 ccritArrayDisgust = nan(1,length(trialStructHolder));
 
 for iRun = 1:length(trialStructHolder)
     runTable = trialStructHolder(iRun).runTable;
     successVector = runTable.success;
     confidenceVector = runTable.sliderResponse;
          trialsToRemove1 = find(isnan(successVector));
          trialsToRemove2 = find(isnan(confidenceVector));
          trialsToRemove = union(trialsToRemove1,trialsToRemove2);
          successVector(trialsToRemove) = [];
          confidenceVector(trialsToRemove) = [];
     dSubArray(iRun) = sdtMeta(successVector,confidenceVector,100,6);
     %Sanity Check - get mean conf for H/M/CR/FA
     hitTable = runTable(runTable.CorrectHitIsOne ==1,:);
     meanConfHitArray(iRun) = nanmean(hitTable.sliderResponse);
     missTable = runTable(runTable.CorrectHitIsOne ==0,:);
     meanConfMissArray(iRun) = nanmean(missTable.sliderResponse);
     faTable = runTable(runTable.FAisOne==1,:);
     meanConfFaArray(iRun) = nanmean(faTable.sliderResponse);
     crTable = runTable(runTable.FAisOne==0,:);
     meanConfCRArray(iRun) = nanmean(crTable.sliderResponse);
     
     dprimeArrayNeutral(iRun) = trialStructHolder(iRun).DprimeNeutralDisgust(1);
     dprimeArrayDisgust(iRun) = trialStructHolder(iRun).DprimeNeutralDisgust(2);
     
     ccritArrayNeutral(iRun) = trialStructHolder(iRun).biasNeutralDisgust(1);
     ccritArrayDisgust(iRun) = trialStructHolder(iRun).biasNeutralDisgust(2);
 end
         if plotFigures == 1

  figure(59)

 bar(dSubArray)
 title('DsubA Values by Subject')
 figure(60)
 scatter(1:nRuns,meanConfHitArray,'*');
 hold on 
 scatter(1:nRuns,meanConfMissArray,'*');
 scatter(1:nRuns,meanConfFaArray,'*');
 scatter(1:nRuns,meanConfCRArray,'*');
 title('Sanity Check: Mean Confidence for Different Outcomes')
 legend('hit','miss','FA','CR')
 xlabel('subject')
 ylabel('mean confidence')
 
 figure(99)
 dPrimeValues = horzcat(dprimeArrayNeutral',dprimeArrayDisgust');
 bar(dPrimeValues,'grouped'); title('Neutral vs. Disgust dPrime By Subject')
 legend('neutral','disgust')
 
  figure(98)
 ccritValues = horzcat(ccritArrayDisgust',ccritArrayNeutral');
 bar(ccritValues,'grouped'); title('Neutral vs. Disgust ccrit By Subject')
 legend('neutral','disgust')
         end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%DO Hakwan Lau's SDT
 %%%%%%%%%%%%%%%%%%%%%%%%%%%Modelt

 for iRun = 1:length(trialStructHolder)
     runTable = trialStructHolder(iRun).runTable;
     sdtData = returnSDTtableFromTable(runTable,4);
     neutralTable = runTable(runTable.disgustCue ==0,:);
     disgustTable = runTable(runTable.disgustCue ==1,:);
     disgustSDTdata = returnSDTtableFromTable(disgustTable,4);
     disgustM_ratio = disgustSDTdata.M_ratio;
     disgustDa = disgustSDTdata.da;
     neutralSDTdata = returnSDTtableFromTable(neutralTable,4);
     neutralDa = neutralSDTdata.da;
     neutralM_ratio = neutralSDTdata.M_ratio;
     MetaD = sdtData.meta_da;
     neutralMetaD = neutralSDTdata.meta_da;
     disgustMetaD = disgustSDTdata.meta_da;
     DaStruct(iRun).neutral = neutralDa;
     DaStruct(iRun).disgust = disgustDa;
     mRatioStruct(iRun).neutral = neutralM_ratio;
     mRatioStruct(iRun).disgust = disgustM_ratio;
     metaDStruct(iRun).neutral = neutralMetaD;
     metaDStruct(iRun).disgust = disgustMetaD;
     metaDStruct(iRun).allTrials = MetaD;
 end
 
 

figure(112)
X = categorical({'Neutral','Disgust'});
bar(X,[mean([mRatioStruct.neutral]),mean([mRatioStruct.disgust])]);
title('mRatio')

figure(111)
X = categorical({'Neutral','Disgust'});
bar(X,[mean([metaDStruct.neutral]),mean([metaDStruct.disgust])]);
title('meta-d')

figure(113)
subplot(1,2,1)
bar([mRatioStruct.disgust])
title('mRatio - Disgust')
subplot(1,2,2)
bar([mRatioStruct.neutral])
title('mRatio - Neutral')

 dSubArray2 = nan(1,2);
 for iRun = 1:2
     successVector = allNeutralTable.success;
     confidenceVector = allNeutralTable.sliderResponse;
     %dSubArray2(1) = sdtMeta(successVector,confidenceVector,100,6);
     
     successVector = allDisgustTable.success;
     confidenceVector = allDisgustTable.sliderResponse;
     %dSubArray2(2) = sdtMeta(successVector,confidenceVector,100,6);
 end
    
 figure(139)
 %A second sanity check for excluding trials
 nNaNArray= nan(length(trialStructHolder),2);
 runCntr = 1;
 for iRun = 1:length(trialStructHolder)
     nSliderResponses = sum(isnan(trialStructHolder(iRun).runTable.sliderResponse));
     nDecisions = sum(isnan(trialStructHolder(iRun).runTable.success));
     
     nNaNArray(iRun,1) = nSliderResponses;
     nNaNArray(iRun,2) = nDecisions;
     
     if nSliderResponses>10
         runIDtracker(runCntr).runID = trialStructHolder(iRun).runID;
         runCntr = runCntr +1;
     end
     if nDecisions>10
                  runIDtracker(runCntr).runID = trialStructHolder(iRun).runID;
         runCntr = runCntr +1;
     end
 end
 bar(nNaNArray,'grouped')
 legend('confidence nonresponses','decision nonresponses')
 title('number of nonresponses by participant, for either confidence or decision')
 grid on 

 figure(140)
 subplot(1,3,3)
 bar(X,[mean([DaStruct.neutral]),mean([DaStruct.disgust])]);
 title('mean participant da (4 conf bins)')
 subplot(1,3,2) 
 neutralBias = nan(1,length(trialStructHolder));
 disgustBias = nan(1,length(trialStructHolder));
 neutralDpri = nan(1,length(trialStructHolder));
 disgustDpri = nan(1,length(trialStructHolder));
 dpriAll = nan(1,length(trialStructHolder));
 for iRun = 1:length(trialStructHolder)
     neutralBias(iRun) = trialStructHolder(iRun).biasNeutralDisgust(1);
     disgustBias(iRun) = trialStructHolder(iRun).biasNeutralDisgust(2);
     neutralDpri(iRun) = trialStructHolder(iRun).DprimeNeutralDisgust(1);
     disgustDpri(iRun) = trialStructHolder(iRun).DprimeNeutralDisgust(2);
     dpriAll(iRun) = trialStructHolder(iRun).dPriAndccrit(1);
 end
 
 bar(X,[mean(neutralBias),mean(disgustBias)]);
 title('mean participant ccrit (> = more rearranged, CR and Miss)')
 subplot(1,3,1)
 bar(X,[mean(neutralDpri),mean(disgustDpri)]);
 title('mean dPrime')
 
 figure(150)
 scatter(dpriAll,[metaDStruct.allTrials])
 xlabel('dprime')
 ylabel('meta-d')
elseif iscell(file)==1 && analysisChoice==1
end