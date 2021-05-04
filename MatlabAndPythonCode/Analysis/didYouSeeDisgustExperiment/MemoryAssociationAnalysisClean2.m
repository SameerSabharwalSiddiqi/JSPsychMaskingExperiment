clear all
%% Add-Paths, Load Data
%Customize Data Analysis
list = {'HvsFAbyBlock','DpriByBlock',... #1 and 2
    'HvsFABySubj',...%3
    'confidenceStatistics',...%4
    'disgustDetectionPlot',... %5
    'nonResponsePlot',...%6
    'actualRecordedTimesByParticipant',...#7
    'QueryAnalysis',...#8
    'sdtAnalysis',...#9
    'aggregateConfidenceAnalysis',...#10
    'mainResults',...#11
    'repeatParticipantChkr'};...#12
    
[indx,tf] = listdlg('ListString',list);

%Bin-Size for SDT analysis (Code from Hakwan Lau Paper).
%e.g. bin-size ==4, means that bins will be [0-25,25-50,50-75,75-100]
sdtBinSize = 4;

%Add paths
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\Analysis')
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\Analysis\memoryAssociationUnblocked')
addpath('C:\Users\16466\Desktop\MaskingExperimentJsPsych\MatlabAndPythonCode\chuaLabCode')

%File selection
[file,path] = uigetfile('*.csv',... 
   'Select One or More Excel Files', ...
   'MultiSelect', 'on');
if iscell(file) == 0 %%not cell array --> single string that corresponds with single file
    resultsCSVstruct(1).filepath = fullfile(path,file);
else %%cell array corresponds with multiple files/multi-selection
     for iCSV = 1:length(file)
        resultsCSVstruct(iCSV).filepath = fullfile(path,file(iCSV));
     end
end
%% Loop through all participants

for iCSV = 1:length(resultsCSVstruct)
        
        if length(resultsCSVstruct) == 1
            resultsCSV = resultsCSVstruct.filepath;
        else
            resultsCSV = resultsCSVstruct(iCSV).filepath{1};
        end
        
        [trialStruct,calibrationStruct,identifier,PreCalibrationQStruct] = AnalysisFunctionMemoryAssociation(resultsCSV);
        runID = trialStruct.runID;
  
        
        %Format Calibration Struct Fields: Disgust Cue and Entry
        disgustCalibrationRaster = strcmp([calibrationStruct.DisgustEntry],'y');
        for iCalibrationTrial = 1:length(calibrationStruct)
            calibrationStruct(iCalibrationTrial).disgustCue = contains(calibrationStruct(iCalibrationTrial).stimulusCue,'DIS.JPG');
            calibrationStruct(iCalibrationTrial).DisgustEntry = disgustCalibrationRaster(iCalibrationTrial);
        end      
        
 %% Assigning Hit and FA trial-by-trial
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

%% Format Values that were previously in string-form
        %They neeeded to be in string for for usage in strcmp() in above
        %Note that NaN Removal is done only after calculating total Nans in
        %below section
        for iTrial = 1:length(trialStruct)
            trialStruct(iTrial).disgustCue = contains(trialStruct(iTrial).stimulusCue,'DIS.JPG');

            sliderResponse = str2double(trialStruct(iTrial).sliderResponse{1});
            isTargetRearranged = str2double(cell2mat(trialStruct(iTrial).isTargetRearranged));
            subjectEntry = trialStruct(iTrial).didSubjectEnterRearranged{1};

            trialStruct(iTrial).sliderResponse = sliderResponse;
            trialStruct(iTrial).isTargetRearranged = isTargetRearranged;
            trialStruct(iTrial).subjectEntry = subjectEntry;
        end      
%% Block Analysis
%%%%%%%%%%%%%%%Begin Analysis%%%%%%%%%%%%%%%%%%%%%
runTable = struct2table(trialStruct);  
if ~isempty(find(indx<3, 1)) %because only the first two graphs are for blocks

        %Block Analysis 
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
            nRearrangedTrials = sum(~isnan(blockTable.FAisOne));
            nIntactTrials = sum(~isnan(blockTable.CorrectHitIsOne));
            FArate = nanmean(blockTable.FAisOne);
            hitRate = nanmean(blockTable.CorrectHitIsOne);
            nNans = nanmean(sum(isnan(blockTable.success))/(length(blockTable.success)));
            [dpri,ccrit] = dprime(hitRate,FArate,nIntactTrials,nRearrangedTrials);

            
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
end
%% By-Participant Statistics
%%%%%%%%%%Calculating Statistics for By-Trial Performance%%%%%%%%%%% 
        %Part 0: Information on Non-Acquisitions (relavent to whether or
        %not to exclude certain participants)
        nDecisionNan = sum(isnan(runTable.success));
        nConfidenceNan = sum(isnan(runTable.sliderResponse));
            %now remove nans
            runTable = removeNansFromTable(runTable); 
            
        %Part 1: Hit and FA-rate across ALL Trials
        nRearrangedTrials = sum(~isnan(runTable.FAisOne));
        nIntactTrials = sum(~isnan(runTable.CorrectHitIsOne));
        FArate = nanmean(runTable.FAisOne);
        hitRate = nanmean(runTable.CorrectHitIsOne);
        [dpri,ccrit] = dprime(hitRate,FArate,nIntactTrials,nRearrangedTrials);
        hitRateConf = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
        faRateConf = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
        %Advanced SDT Data
        if ~isempty(find(indx==9, 1))
            SDTstatistics = returnSDTtableFromTable(runTable,sdtBinSize);
            %SDTstatistics.daChuaCode = sdtMeta([runTable.success], [runTable.sliderResponse], 101, sdtBinSize);
        end
        
        %Part 3: Hit, FA, and confidence statistics for subset of trials
            %2-by-2 division of trials
            %Part 3.1: dividing into neutral and disgust
            neutralTable = runTable(runTable.disgustCue==0,:);
                    %SDT Data
                    nIntactTrialsNeutral = sum(~isnan(neutralTable.CorrectHitIsOne));
                    nRearrangedTrialsNeutral = sum(~isnan(neutralTable.FAisOne));
                    FArateNeutral = nanmean(neutralTable.FAisOne);
                    hitRateNeutral = nanmean(neutralTable.CorrectHitIsOne);
                    nNansNeutral = nanmean(sum(isnan(neutralTable.success))/(length(neutralTable.success)));
                    [dpriNeutral,ccritNeutral] = dprime(hitRateNeutral,FArateNeutral,nIntactTrialsNeutral,nRearrangedTrialsNeutral);
                    %Conf Data
                    neutralMeanConf = nanmean(neutralTable.sliderResponse);
                    neutralConfStd= nanstd(neutralTable.sliderResponse);
                    %Advanced SDT Data
                    if ~isempty(find(indx==9, 1))
                        neutralSDTstatistics = returnSDTtableFromTable(neutralTable,sdtBinSize);
                        %neutralSDTstatistics.daChuaCode = sdtMeta([neutralTable.success], [neutralTable.sliderResponse], 101, sdtBinSize);
                    end
                    
            disgustTable = runTable(runTable.disgustCue==1,:);
                    nIntactTrialsDisgust = sum(~isnan(disgustTable.CorrectHitIsOne));
                    nRearrangedTrialsDisgust = sum(~isnan(disgustTable.FAisOne));
                    FArateDisgust = nanmean(disgustTable.FAisOne);
                    hitRateDisgust = nanmean(disgustTable.CorrectHitIsOne);
                    nNansDisgust = sum(isnan(disgustTable.success))/(length(disgustTable.success));
                    [dpriDisgust,ccritDisgust] = dprime(hitRateDisgust,FArateDisgust,nIntactTrialsDisgust,nRearrangedTrialsDisgust);
                    %Conf Data
                    disgustMeanConf = nanmean(disgustTable.sliderResponse);
                    disgustConfStd = nanstd(disgustTable.sliderResponse);
                    %Advanced SDT Data
                    if ~isempty(find(indx==9, 1))
                        disgustSDTstatistics = returnSDTtableFromTable(disgustTable,sdtBinSize);
                        %disgustSDTstatistics.daChuaCode = sdtMeta([disgustTable.success], [disgustTable .sliderResponse], 101, sdtBinSize);
                    end
                    
            %Part 3.2: dividing into hit and FA
            hitTable = runTable(runTable.CorrectHitIsOne==1,:);
                hitMeanConf = nanmean(hitTable.sliderResponse);
                hitConfStd = nanstd(hitTable.sliderResponse);
            faTable = runTable(runTable.FAisOne==1,:);
                faMeanConf = nanmean(faTable.sliderResponse);
                faConfStd = nanstd(faTable.sliderResponse);
        
            %Part 3.3: dividing into neutral_hit,neutral_FA,disgust_hit,and
            %disgust_FA
            hitNeutralTable = hitTable(hitTable.disgustCue==0,:);
                neutralHitMeanConf = nanmean(hitNeutralTable.sliderResponse);
                neutralHitConfStd = nanstd(hitNeutralTable.sliderResponse);
            hitDisgustTable = hitTable(hitTable.disgustCue==1,:);
                disgustHitMeanConf = nanmean(hitDisgustTable.sliderResponse);
                disgustHitConfStd = nanstd(hitDisgustTable.sliderResponse);
            faNeutralTable = faTable(faTable.disgustCue==0,:);
                neutralFaMeanConf = nanmean(faNeutralTable.sliderResponse);
                neutralFaConfStd = nanstd(faNeutralTable.sliderResponse);
            faDisgustTable = faTable(faTable.disgustCue==1,:);
                disgustFaMeanConf = nanmean(faDisgustTable.sliderResponse);
                disgustFaConfStd = nanstd(faDisgustTable.sliderResponse);
    %% trialStruct Loading
        %non-analysis
        PreCalibrationQHolder(iCSV).writeInQuestion = PreCalibrationQStruct.writeInQuestion;
        PreCalibrationQHolder(iCSV).multiselect = PreCalibrationQStruct.multiSelect;
        trialStructHolder(iCSV).runTable = runTable;
        trialStructHolder(iCSV).runID = runID;
        trialStructHolder(iCSV).identifier = identifier;   
        trialStructHolder(iCSV).meanRecordedCueTime = nanmean([trialStruct.recordedCueTime]);
        trialStructHolder(iCSV).calibrationStruct = calibrationStruct;

        
        %nonResponseData 
        trialStructHolder(iCSV).DecisionNonResponse = nDecisionNan;
        trialStructHolder(iCSV).ConfidenceNonResponse = nConfidenceNan;
        %hitRate
        trialStructHolder(iCSV).hitRateAllTrials = hitRate;
        trialStructHolder(iCSV).hitRateNeutralTrials = hitRateNeutral;
        trialStructHolder(iCSV).hitRateDisgustTrials = hitRateDisgust;
        
        %faRate
        trialStructHolder(iCSV).faRateAllTrials = FArate;
        trialStructHolder(iCSV).faRateNeutralTrials = FArateNeutral;
        trialStructHolder(iCSV).faRateDisgustTrials = FArateDisgust;
        
        %dPrime
        trialStructHolder(iCSV).dPrimeAllTrials = dpri;
        trialStructHolder(iCSV).dPrimeNeutralTrials = dpriNeutral;
        trialStructHolder(iCSV).dPrimeDisgustTrials = dpriDisgust;
        
        %C-Criterion
        trialStructHolder(iCSV).ccritAllTrials = ccrit;
        trialStructHolder(iCSV).ccritNeutralTrials = ccritNeutral;
        trialStructHolder(iCSV).ccritDisgustTrials = ccritDisgust;
        
        %sliderResponse/Confidence statistics
        trialStructHolder(iCSV).confMeanNeutralTrials = neutralMeanConf;
        trialStructHolder(iCSV).confMeanDisgustTrials = disgustMeanConf;
        trialStructHolder(iCSV).confMeanHitTrials = hitMeanConf;
        trialStructHolder(iCSV).confMeanFaTrials = faMeanConf;
        trialStructHolder(iCSV).confMeanNeutralHitTrials = neutralHitMeanConf;
        trialStructHolder(iCSV).confMeanNeutralFaTrials = neutralFaMeanConf;
        trialStructHolder(iCSV).confMeanDisgustHitTrials = disgustHitMeanConf;
        trialStructHolder(iCSV).confMeanDisgustFaTrials = disgustFaMeanConf;
        
        trialStructHolder(iCSV).confStdNeutralTrials = neutralConfStd;
        trialStructHolder(iCSV).confStdDisgustTrials = disgustConfStd;
        trialStructHolder(iCSV).confStdHitTrials = hitConfStd;
        trialStructHolder(iCSV).confStdFaTrials = faConfStd;
        trialStructHolder(iCSV).confStdNeutralHitTrials = neutralHitConfStd;
        trialStructHolder(iCSV).confStdNeutralFaTrials = neutralFaConfStd;
        trialStructHolder(iCSV).confStdDisgustHitTrials = disgustHitConfStd;
        trialStructHolder(iCSV).confStdDisgustFaTrials = disgustFaConfStd;
        
        %Advanced SDT Statistics
        if ~isempty(find(indx==9, 1))
            trialStructHolder(iCSV).SDTstatisticsAll = SDTstatistics;
            trialStructHolder(iCSV).SDTstatisticsNeutral = neutralSDTstatistics;
            trialStructHolder(iCSV).SDTstatisticsDisgust = disgustSDTstatistics;
        end
        
    %% by-subject plots
        
        %Figure 3 plots Hits vs. FA by subject%%%%%%%
        if ~isempty(find(indx==3, 1))
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
        
        %Figure 4 plots mean/std of slider response for 4 categories.
        if ~isempty(find(indx==4, 1))
        figure(4)
        subplot(1,length(resultsCSVstruct),iCSV) 
        barwitherr([neutralHitConfStd,neutralFaConfStd,disgustHitConfStd,disgustFaConfStd],[neutralHitMeanConf,neutralFaMeanConf,disgustHitMeanConf,disgustFaMeanConf])
        set(gca,'XTickLabel',{'NH','NFA','DH','DFA'})
        ylabel('Confidence/Slider-Response')
        title('Confidence Statistics Across Subjects,Expressions, and Hit/FA Trial')
        
        
        %Figure 5 plots mean/std of slider response for just hit and fa
        %(basically a sanity-check)
        figure(5)
        subplot(1,length(resultsCSVstruct),iCSV)
        barwitherr([hitConfStd,faConfStd],[hitMeanConf,faMeanConf]);
        set(gca,'XTickLabel',{'Hit','FA'})
        ylabel('Confidence/Slider-Response')
        title('Confidence Statistics Across Subjects and Hit/FA Trial')
        end
        
       
          
        %% Analysis and Plot for Calibration Struct (fiure 5)%%%%%%%%%%%%%%%%%%%
        if ~isempty(find(indx==5, 1))
            calibrationTable = struct2table(calibrationStruct);
            disgustTableCalibration = calibrationTable(calibrationTable.disgustCue == 1,:);
            neutralTableCalibration = calibrationTable(calibrationTable.disgustCue == 0,:);

            hitRateDisgust = nanmean(disgustTableCalibration.DisgustEntry);
            nDisgustTrials = sum(~isnan(disgustTableCalibration.DisgustEntry));
            hitRateConfDisgust = 1.96*sqrt((hitRateDisgust*(1-hitRateDisgust))/nDisgustTrials);

            faRateNeutral = nanmean(neutralTableCalibration.DisgustEntry);
            nNeutralTrials = sum(~isnan(neutralTableCalibration.DisgustEntry));
            faRateConfNeutral = 1.96*sqrt((faRateNeutral*(1-faRateNeutral))/nNeutralTrials);

            figure(6)
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
end %end of participant loop 
%% Miscelaneous Plots - NonResponses and Average Recorded Cue-Time

if ~isempty(find(indx==6, 1)) 
figure(7)
decisionNaNVector = [trialStructHolder.DecisionNonResponse]';
confNanVector = [trialStructHolder.ConfidenceNonResponse]';
nanMat = horzcat(decisionNaNVector,confNanVector);
bar([1:length(trialStructHolder)],[nanMat],'grouped')
 grid on 
legend('Decision Non-Responses','Confidence Non-Responses');
%a "mini-gui" for identifying the bad players
thresholdForUnacceptableNaNs = 15;
runIDofBadParticipants =  [trialStructHolder([trialStructHolder.ConfidenceNonResponse]>thresholdForUnacceptableNaNs).runID];
end

if ~isempty(find(indx==7, 1))
%Plot Avg. actual RECORDED Cue-Time By Participant%%
figure(8) 
bar([trialStructHolder.meanRecordedCueTime])
xlabel('subject')
ylabel('Avg Cue Time')
title('Average ACTUAL cue time for each subject')
end



%Plot: How many subjects entered that they saw a disgust face?  
%% Basic Aggregate Plots - Basic SDT
X = categorical({'Neutral','Disgust'});
Y = categorical({'allTrials'});

%Hit vs. FA
figure(10)
subplot(1,3,1)
errorbar(1,mean([trialStructHolder.hitRateAllTrials]),std([trialStructHolder.hitRateAllTrials]),'*');
hold on 
errorbar(1,mean([trialStructHolder.faRateAllTrials]),std([trialStructHolder.faRateAllTrials]),'*');
legend('hit','fa')
title('mean Hit and Fa for all Participants')
subplot(1,3,2)
errorbar(1,mean([trialStructHolder.hitRateDisgustTrials]),std([trialStructHolder.hitRateDisgustTrials]),'*');
hold on 
errorbar(1,mean([trialStructHolder.faRateDisgustTrials]),std([trialStructHolder.faRateDisgustTrials]),'*');
legend('hit','fa')
title('mean Hit and Fa for Neutral Trials')
subplot(1,3,3)
errorbar(1,mean([trialStructHolder.hitRateNeutralTrials]),std([trialStructHolder.hitRateNeutralTrials]),'*');
hold on 
errorbar(1,mean([trialStructHolder.faRateNeutralTrials]),std([trialStructHolder.faRateNeutralTrials]),'*');
legend('hit','fa')
title('mean Hit and Fa for Disgust Trials')

%Questionnare Analyssi
if ~isempty(find(indx==8, 1))
 disgustSelectedCntr = 0;
 for iQuestion = 1:length(PreCalibrationQHolder)
     if contains(PreCalibrationQHolder(iQuestion).multiselect{1},'Disgust')
     disgustSelectedCntr = disgustSelectedCntr + 1;
     end
 end
 preQTable = struct2table(PreCalibrationQHolder); %useful for viewing subjective responses
end

if ~isempty(find(indx==10, 1))
%Variation in confidnece / slider response across conditions 
figure(11)
subplot(1,2,1)
barwitherr([mean([trialStructHolder.confStdHitTrials]),mean([trialStructHolder.confStdFaTrials])]...
    ,[mean([trialStructHolder.confMeanHitTrials]),mean([trialStructHolder.confMeanFaTrials])]);
set(gca,'XTickLabel',{'Hits','FA'})
title('confidence responses for Hit versus FA')

subplot(1,2,2)
barwitherr([mean([trialStructHolder.confStdNeutralHitTrials]),mean([trialStructHolder.confStdNeutralFaTrials]),...
    mean([trialStructHolder.confStdDisgustHitTrials]),mean([trialStructHolder.confStdDisgustFaTrials])],...
    [mean([trialStructHolder.confMeanNeutralHitTrials]),mean([trialStructHolder.confMeanNeutralFaTrials]),...
    mean([trialStructHolder.confMeanDisgustHitTrials]),mean([trialStructHolder.confMeanDisgustFaTrials])])
set(gca,'XTickLabel',{'NH','NFA','DH','DFA'})
title('confidence responses across 4 conditions')
end

if ~isempty(find(indx==11, 1))
%dPrime, C-Criterion, dSubA (Hakwan Code), metaD. Between Neutral vs Disgust

%First, load da and meta_da stats
%all trials
allSDTStatisticsHolder = [trialStructHolder.SDTstatisticsAll];
neutralSDTStatisticsHolder = [trialStructHolder.SDTstatisticsNeutral];
disgustSDTStatisticsHolder = [trialStructHolder.SDTstatisticsDisgust];
    daArrayAll = [allSDTStatisticsHolder.da];
    metaDArrayAll = [allSDTStatisticsHolder.meta_da];
    
    daArrayNeutral = [neutralSDTStatisticsHolder.da];
    metaDArrayNeutral = [neutralSDTStatisticsHolder.meta_da];
    
    daArrayDisgust = [disgustSDTStatisticsHolder.da];
    metaDArrayDisgust = [disgustSDTStatisticsHolder.meta_da];

figure(12)
    subplot(2,4,1) %Top - all Trials, Bottom - Neutral vs. Disgust
        barwitherr(std([trialStructHolder.dPrimeAllTrials]),mean([trialStructHolder.dPrimeAllTrials]))
        title('d-Prime Across Participants')
    subplot(2,4,5) %Bottom - dPrime N vs. D
        barwitherr([std([trialStructHolder.dPrimeNeutralTrials]),std([trialStructHolder.dPrimeDisgustTrials])],...
                       [mean([trialStructHolder.dPrimeNeutralTrials]),std([trialStructHolder.dPrimeDisgustTrials])])
        set(gca,'XTickLabel',{'Neutral','Disgust'})
        
    subplot(2,4,2) %C-Criterion
        barwitherr(std([trialStructHolder.ccritAllTrials]),mean([trialStructHolder.ccritAllTrials]))
        title('C-Criterion. Negative->Intact Bias')
    subplot(2,4,6)
        barwitherr([std([trialStructHolder.ccritNeutralTrials]),std([trialStructHolder.ccritDisgustTrials])],...
                        [mean([trialStructHolder.ccritNeutralTrials]),mean([trialStructHolder.ccritDisgustTrials])]);
        set(gca,'XTickLabel',{'Neutral','Disgust'})
    
    subplot(2,4,3) %DA
        barwitherr(std(daArrayAll),mean(daArrayAll));
        title('Da')
    subplot(2,4,7)
        barwitherr([std(daArrayNeutral),std(daArrayDisgust)],...
                    [mean(daArrayNeutral),mean(daArrayDisgust)])
    set(gca,'XTickLabel',{'Neutral','Disgust'})
    
    subplot(2,4,4) %meta-D
        barwitherr(std(metaDArrayAll),mean(metaDArrayAll));
        title('meta-D')
    subplot(2,4,8)
        barwitherr([std(metaDArrayNeutral),std(metaDArrayDisgust)],...
                     [mean(metaDArrayNeutral),mean(metaDArrayDisgust)])
         set(gca,'XTickLabel',{'Neutral','Disgust'})        


end

%Check for repeat subs

if ~isempty(find(indx==12, 1))
    clear runsToDelete
    clear repeatParticipantStruct
    repeatParticipantCntr = 1;
    repeatedRunCntr = 1;
    for iRun = 1:length(trialStructHolder)
        partKey = trialStructHolder(iRun).identifier;
        participantAppearsNtimes = count([trialStructHolder.identifier],partKey);
        if participantAppearsNtimes > 1
            if repeatParticipantCntr == 1
            repeatParticipantStruct(repeatParticipantCntr).Key = partKey;
            repeatParticipantStruct(repeatParticipantCntr).participantAppearsNtimes = participantAppearsNtimes;
            repeatParticipantStruct(repeatParticipantCntr).runID = trialStructHolder(iRun).runID;
            repeatParticipantCntr = repeatParticipantCntr + 1;
            elseif contains([repeatParticipantStruct.Key],partKey) %don't double-count repeat participants
            runsToDelete(repeatedRunCntr).runID = trialStructHolder(iRun).runID;
            runsToDelete(repeatedRunCntr).partKey = trialStructHolder(iRun).identifier;            
            repeatedRunCntr = repeatedRunCntr+1;
            else
            repeatParticipantStruct(repeatParticipantCntr).Key = partKey;
            repeatParticipantStruct(repeatParticipantCntr).participantAppearsNtimes = participantAppearsNtimes;
            repeatParticipantStruct(repeatParticipantCntr).runID = trialStructHolder(iRun).runID;
            repeatParticipantCntr = repeatParticipantCntr + 1;
            end
        end
    end
    
    keysOfoffendingParticipants = [repeatParticipantStruct.Key];
    
end
 
 %Commented-Out: Code for figures that I am no longer interested in 
 %1: code for HvsFa by "confBlock," meant to be within subject-loop 
%  
%          %Figure(8) - confidence to H and FA rate confidence curves 
%         confBlocks = [0 33 66 100];
%         
%         %CONF blockHolder
%         nConfBlocks = length(confBlocks)-1;
%         nXconfMeans = nan(1,nConfBlocks);
%         confblockHitRateHolder = nan(1,nConfBlocks);
%         confblockHitConfHolder = nan(1,nConfBlocks);
%         confblockFArateHolder = nan(1,nConfBlocks);
%         confblockFAconfHolder = nan(1,nConfBlocks);
%         confnanHolder = nan(1,nConfBlocks);
%         confNObservations = nan(1,nConfBlocks);
%         %And holder for sdt measures. 
%         confblockDprimeHolder = nan(1,nConfBlocks);
%         confblockBiasHolder = nan(1,nConfBlocks);
%         for iConfBlock = 1:nConfBlocks
%             lowBar = confBlocks(iConfBlock);
%             hiBar = confBlocks(iConfBlock+1);
%             nXconfMeans(iConfBlock) = mean(lowBar,hiBar);
%             hiTable = runTable(runTable.sliderResponse>lowBar,:);
%             confTable = hiTable(hiTable.sliderResponse<hiBar,:);
%             
%             
%             nIntactTrials = sum(~isnan(confTable.FAisOne));
%             nRearrangedTrials = sum(~isnan(confTable.CorrectHitIsOne));
%             FArate = nanmean(confTable.FAisOne);
%             hitRate = nanmean(confTable.CorrectHitIsOne);
%             NanRate = nanmean(sum(isnan(confTable.success))/(length(confTable.success)));
%             [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
%             nObservations = height(confTable);
% 
%             
%             confblockHitRateHolder(iConfBlock) = hitRate;
%             confblockHitConfHolder(iConfBlock) = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
%             
%             confblockFArateHolder(iConfBlock) = FArate;
%             confblockFAconfHolder(iConfBlock) = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
%             
%             confnanHolder(iConfBlock) = NanRate;
%             confNObservations(iConfBlock) = nObservations;
%             
%             confblockDprimeHolder(iConfBlock) = dpri;
%             blockBiasHolder(iConfBlock) = ccrit;
%         end
%         
%         if plotFigures ==1
% 
%         figure(8)
%         hold on 
%         %Top Plot: Confidence Prediction Accuracy (Hit Rate etc.)
%         subplot(1,length(resultsCSVstruct),iCSV) 
%         confhitByBlockGraph = errorbar([nXconfMeans],[confblockHitRateHolder],[confblockHitConfHolder]);
%         confhitByBlockGraph.LineWidth = 3;
%         hold on
%         confFAbyBlockGraph = errorbar([nXconfMeans],[confblockFArateHolder],[confblockFAconfHolder]);
%         confFAbyBlockGraph.LineWidth = 3;
%         confNaNLine = plot([nXconfMeans],[confnanHolder]);
%         confNaNLine.LineWidth = 2;
%         confNaNLine.Color = 'k';
%         xlabel(runID)
%         ylim([0 1])
%         if iCSV ==1
%         legend('hit rate','FA rate','No Entry %','Location','Northeast')
%         end
%         ylabel('%')
%         title(identifier) 
%         
%         figure(81)
%         %Bottom Plot: nObservationsPerBlock 
%         subplot(1,length(resultsCSVstruct),iCSV) 
%         bar([nXconfMeans],[confNObservations])
%         ylabel('nObservations')
%         xlabel(runID)
%         ylim([0 60])
%         title(identifier) 
%         end


%2: Code that aggregates ALL data and derives disgust vs. neutral plots
    % aggregateData = vertcat(trialStructHolder.runTable);
    % aggregateData = aggregateData(aggregateData.recordedCueTime<=33,:);
    % allNeutralTable = aggregateData(aggregateData.disgustCue==0,:);
    % allDisgustTable = aggregateData(aggregateData.disgustCue==1,:);
    % aggregateTableStruct(1).table = allNeutralTable;
    % aggregateTableStruct(2).table = allDisgustTable;
    % for i = 1:2
    %         aggTable = aggregateTableStruct(i).table;
    %         %Figure(10) - confidence to H and FA rate for ALL data, between
    %         %NEutral and DIsgust
    %         confBlocks = [0 33 66 100];
    %         
    %         %CONF blockHolder
    %         nConfBlocks = length(confBlocks)-1;
    %         nXconfMeans = nan(1,nConfBlocks);
    %         confblockHitRateHolder = nan(1,nConfBlocks);
    %         confblockHitConfHolder = nan(1,nConfBlocks);
    %         confblockFArateHolder = nan(1,nConfBlocks);
    %         confblockFAconfHolder = nan(1,nConfBlocks);
    %         confnanHolder = nan(1,nConfBlocks);
    %         confNObservations = nan(1,nConfBlocks);
    %         %And holder for sdt measures. 
    %         confblockDprimeHolder = nan(1,nConfBlocks);
    %         confblockBiasHolder = nan(1,nConfBlocks);
    %         for iConfBlock = 1:nConfBlocks
    %             lowBar = confBlocks(iConfBlock);
    %             hiBar = confBlocks(iConfBlock+1);
    %             nXconfMeans(iConfBlock) = mean(lowBar,hiBar);
    %             hiTable = aggTable(aggTable.sliderResponse>lowBar,:);
    %             confTable = hiTable(hiTable.sliderResponse<hiBar,:);
    %             
    %             
    %             nIntactTrials = sum(~isnan(confTable.FAisOne));
    %             nRearrangedTrials = sum(~isnan(confTable.CorrectHitIsOne));
    %             FArate = nanmean(confTable.FAisOne);
    %             hitRate = nanmean(confTable.CorrectHitIsOne);
    %             NanRate = nanmean(sum(isnan(confTable.success))/(length(confTable.success)));
    %             [dpri,ccrit] = dprime(hitRate,FArate,nRearrangedTrials,nIntactTrials);
    %             nObservations = height(confTable);
    % 
    %             
    %             confblockHitRateHolder(iConfBlock) = hitRate;
    %             confblockHitConfHolder(iConfBlock) = 1.96*sqrt((hitRate*(1-hitRate))/nRearrangedTrials);
    %             
    %             confblockFArateHolder(iConfBlock) = FArate;
    %             confblockFAconfHolder(iConfBlock) = 1.96*sqrt((FArate*(1-FArate))/nIntactTrials);
    %             
    %             confnanHolder(iConfBlock) = NanRate;
    %             confNObservations(iConfBlock) = nObservations;
    %             
    %             confblockDprimeHolder(iConfBlock) = dpri;
    %             blockBiasHolder(iConfBlock) = ccrit;
    %         end
    %           if plotFigures ==1
    % 
    %         figure(10)
    %         hold on 
    %         %Top Plot: Confidence Prediction Accuracy (Hit Rate etc.)
    %         subplot(2,2,i) 
    %         confhitByBlockGraph = errorbar([nXconfMeans],[confblockHitRateHolder],[confblockHitConfHolder]);
    %         confhitByBlockGraph.LineWidth = 3;
    %         hold on
    %         confFAbyBlockGraph = errorbar([nXconfMeans],[confblockFArateHolder],[confblockFAconfHolder]);
    %         confFAbyBlockGraph.LineWidth = 3;
    %         confNaNLine = plot([nXconfMeans],[confnanHolder]);
    %         confNaNLine.LineWidth = 2;
    %         confNaNLine.Color = 'k';
    %         xlabel('midpoint of Confidence Bin')
    %         ylim([0 1])
    %         if iCSV ==1
    %         legend('hit rate','FA rate','No Entry %','Location','Northwest')
    %         end
    %         ylabel('%')
    %         if i == 1
    %         title('All Neutral Cue Trials. Recorded Cue TIme')
    %         legend('Hit Rate','FA Rate','Null Rate','Location','Northeast')
    %         elseif i == 2
    %         title('All Disgust Cue Trials. Recorded Cue Time')
    %         end
    %         
    %         %Bottom Plot: nObservationsPerBlock 
    %         subplot(2,2,i+2) 
    %         bar([nXconfMeans],[confNObservations])
    %         ylabel('nObservations')
    %         xlabel('midpoint of Confidence Bin')
    %         ylim([0 1000])
    %           end
    % end
