% look for predictive fit of actual time at 30ms and performance at 30ms
% (using logistic regression). 

%use aggstruct from analysis.m
aggTable = struct2table(aggStruct);
aggTable30ms= aggTable(aggTable.CueDuration == 33,:);

figure(11)
hist(aggTable30ms.recordedTime,120)
title('distribution of actual cue time when cue time was meant to be 33ms')
xlabel('ms')
ylabel('count')
xticks([30:3:102])


mdlspec = 'Success ~ recordedTime';
mdl = fitglm(aggTable30ms,mdlspec,'Distribution','binomial');
        
aggTable30msHits = aggTable30ms(aggTable30ms.oneForDisgustTrial == 1,:);
mdlHitsOnly = fitglm(aggTable30msHits,mdlspec);


bins = [33,36,39,42];
for iBin = 1:(length(bins)-1)
    lowBar = bins(iBin);
    hiBar = bins(iBin+1);
    hiTable = aggTable30ms(aggTable30ms.recordedTime>lowBar,:);
    binTable = hiTable(hiTable.recordedTime<hiBar,:);
    binStruct(iBin).binCenter = mean(lowBar,hiBar);
     Success = mean(binTable.Success);
     binStruct(iBin).Success = Success;
    binStruct(iBin).confInt = 1.96*sqrt((Success*(1-Success))/height(binTable));
end

figure(12)
barfor30ms = errorbar([binStruct.binCenter],[binStruct.Success],[binStruct.confInt]);
title('Performance at 30ms INTENDED cue-time, depending on ACTUAL cue-time duration')
ylabel('(Hit+Correct Rejection)/(False Alarm+False Rejection)')
grid on
xlim([32,40])
barfor30ms.LineWidth = 2;
ylim([0 1.1]);
yticks([0:.1:1.1]);
xlabel('ms')
