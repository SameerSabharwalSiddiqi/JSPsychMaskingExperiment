function [SDTanalysis] = returnSDTtableFromTable(runTable,nBins)

binEdges = 0:(100/nBins):100;    
nBins = length(binEdges) -1;

SR1 = runTable(runTable.isTargetRearranged == 0,:);
SR2 = runTable(runTable.isTargetRearranged == 1,:);

SR1success = SR1(SR1.success ==1,:);
SR1failure = SR1(SR1.success==0,:);

SR1SuccessTally = nan(1,nBins);
SR1FailureTally = nan(1,nBins);
for i = 1:nBins
    binEdge1 = binEdges(i);
    binEdge2 = binEdges(i+1);
    hiTable = SR1success(SR1success.sliderResponse>binEdge1,:);
    binTable = hiTable(hiTable.sliderResponse<binEdge2,:);
    SR1SuccessTally(i) = height(binTable);
end
for i = 1:nBins
    binEdge1 = binEdges(i);
    binEdge2 = binEdges(i+1);
    hiTable = SR1failure(SR1failure.sliderResponse>=binEdge1,:);
    if i < nBins
    binTable = hiTable(hiTable.sliderResponse<binEdge2,:);
    elseif i == nBins
    binTable = hiTable(hiTable.sliderResponse<=binEdge2,:);   %for last bin, make sure it is inclusive of maximum conf value
    end
    SR1FailureTally(i) = height(binTable);
end

SR1SuccessTally = flip(SR1SuccessTally);
SR1confTally = horzcat(SR1SuccessTally,SR1FailureTally);

%%%%%%%%%%%%%%%%%%SR2
SR2success = SR2(SR2.success ==1,:);
SR2failure = SR2(SR2.success==0,:);

SR2SuccessTally = nan(1,nBins);
SR2FailureTally = nan(1,nBins);
for i = 1:nBins
    binEdge1 = binEdges(i);
    binEdge2 = binEdges(i+1);
    hiTable = SR2success(SR2success.sliderResponse>binEdge1,:);
    binTable = hiTable(hiTable.sliderResponse<binEdge2,:);
    SR2SuccessTally(i) = height(binTable);
end
for i = 1:nBins
    binEdge1 = binEdges(i);
    binEdge2 = binEdges(i+1);
    hiTable = SR2failure(SR2failure.sliderResponse>=binEdge1,:);
    if i < nBins
    binTable = hiTable(hiTable.sliderResponse<binEdge2,:);
    elseif i == nBins
    binTable = hiTable(hiTable.sliderResponse<=binEdge2,:);   %for last bin, make sure it is inclusive of maximum conf value
    end
    SR2FailureTally(i) = height(binTable);
end

SR2SuccessTally = flip(SR2SuccessTally);
SR2confTally = horzcat(SR2SuccessTally,SR2FailureTally);

SDTanalysis = type2_SDT_SSE(SR1confTally, SR2confTally);
end
