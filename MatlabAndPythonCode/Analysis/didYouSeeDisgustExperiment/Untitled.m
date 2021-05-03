function [SDTanalysisNeutral,SDTanalysisDisgust] = returnNeutralDisgustSDT(runTable)

SR1success = SR1(SR1.success ==1,:);
SR1failure = SR1(SR1.success==0,:);

SR1success = sortrows(SR1success,'sliderResponse','descend');
SR1failure = sortrows(SR1failure,'sliderResponse','ascend');

SR1confTally = zeros(101*2,1);
for i = 1:101
    conf = 101-i;
    SR1confTally(i) = sum(SR1success.sliderResponse==conf);
end
for i = 1:101
    conf = i -1;
    SR1confTally(203-i) = sum(SR1failure.sliderResponse==conf);
end

SR2success = SR2(SR2.success ==1,:);
SR2failure = SR2(SR2.success==0,:);

SR2success = sortrows(SR2success,'sliderResponse','descend');
SR2failure = sortrows(SR2failure,'sliderResponse','ascend');


SR2confTally = zeros(101*2,1);
for i = 1:101
    conf = i;
    SR2confTally(i) = sum(SR2success.sliderResponse==conf);
end
for i = 1:101
    conf = i -1;
    SR2confTally(203-i) = sum(SR2failure.sliderResponse==conf);
end
SDTanalysis = type2_SDT_SSE(SR1confTally, SR2confTally);


 dSubArray2 = nan(1,2);
 for iRun = 1:2
     successVector = allNeutralTable.success;
     confidenceVector = allNeutralTable.sliderResponse;
     %dSubArray2(1) = sdtMeta(successVector,confidenceVector,100,6);
     
     successVector = allDisgustTable.success;
     confidenceVector = allDisgustTable.sliderResponse;
     %dSubArray2(2) = sdtMeta(successVector,confidenceVector,100,6);
 end
 
end
