trialTable = readtable('sampleData/maskedfacecopypaste5.csv');
clear runningStr

stimCntr=1;
for i = 1:max(size(trialTable))
    phase = trialTable.Phase(i);
    if strcmp('Cue',phase)
        runningStr(stimCntr)= trialTable.stimulus(i);
        runningStr(stimCntr) = trialTable.stimulus(i);
        stimCntr= stimCntr+1;
    end
end
