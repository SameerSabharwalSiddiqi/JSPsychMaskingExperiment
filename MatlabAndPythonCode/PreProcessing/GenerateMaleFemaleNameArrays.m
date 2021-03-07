nameTable = readtable('memoryAssociationPhase/names.xlsx');

totalPerGender = 80;
maleNames = nameTable.MaleName;
femaleNames = nameTable.FemaleName;

maleNames = maleNames(1:totalPerGender);
femaleNames = femaleNames(1:totalPerGender);

%randomize order 
maleNames = maleNames(randperm(numel(maleNames)));
femaleNames = femaleNames(randperm(numel(femaleNames)));

maleString = cellfun(@string,maleNames);
femaleString = cellfun(@string,femaleNames);
 
maleString = join(maleString,"','");
maleString = append("['",maleString,"']");

femaleString = join(femaleString,"','");
femaleString = append("['",femaleString,"']");

fprintf(femaleString);
fprintf('\n')
fprintf(maleString);
