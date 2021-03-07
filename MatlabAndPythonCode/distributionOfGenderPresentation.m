function [trialStruct,combinationStruct] = distributionOfGenderPresentation(trialStruct)
nTrials = length(trialStruct);
for iTrial = 1:nTrials
    genderArray = [NaN NaN NaN];
    cueGender = trialStruct(iTrial).maleFaceGenderCue;
    maskGender = trialStruct(iTrial).maleFaceGenderNeutralMask;
    targetGender = trialStruct(iTrial).maleFaceGenderRecollection;
    
    genderArray(1) = cueGender;
    genderArray(2) = maskGender;
    genderArray(3) = targetGender;
    trialStruct(iTrial).genderArray = genderArray;
end
genderArrayTable = vertcat(trialStruct.genderArray);
uniqueCombinations = unique(genderArrayTable,'rows');
nUniqueCombinations = length(uniqueCombinations);

for iCombination = 1:nUniqueCombinations
    combinationCntr = 0;
    combination = uniqueCombinations(iCombination,:);
    for iTrial = 1:nTrials
        genderArray = trialStruct(iTrial).genderArray;
        if isequal(genderArray,combination)
            combinationCntr = combinationCntr +1;
        end
        if combination == [0 0 0]
            genderKey = 'FFF';
        elseif combination == [0 0 1]
            genderKey = 'FFM';
        elseif combination == [0 1 0]
            genderKey = 'FMF';
        elseif combination == [1 0 0]
            genderKey = 'MFF';
        elseif combination == [1 1 0]
            genderKey = 'MMF';
        elseif combination == [0 1 1]
            genderKey = 'FMM';
        elseif combination == [1 0 1]
            genderKey = 'MFM';
        elseif combination == [1 1 1]
            genderKey = 'MMM';
        end
        combinationStruct(iCombination).combination = combination;
        combinationStruct(iCombination).count = combinationCntr;
        combinationStruct(iCombination).genderKey = genderKey;
    end
end
end

