function runTable = removeNansFromTable(runTable)    

trialsToRemove1 = find(isnan(runTable.success));
trialsToRemove2 = find(isnan(runTable.sliderResponse));
trialsToRemove = union(trialsToRemove1,trialsToRemove2);
runTable(trialsToRemove,:) = [];
end