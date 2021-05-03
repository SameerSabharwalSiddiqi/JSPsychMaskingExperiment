%Two Changes made - address with Elizabeth 
%1, if confidence value in sdtSorted is NaN, then I am making all other variables in sdtSorted row NaN
%as well. Without this if-catch, the program fails, as it does not expect
%nan in confidence column

%2, adding nansum to tmpfreq calculations for both FC and RC (instead of
%just sum). 

function da = sdtMeta(correct, conf, Nratings, downsample)
% correct - vector of 1 x ntrials, 0 for error, 1 for correct
% conf - vector of 1 x ntrials of confidence ratings taking values 1:Nratings
% Nratings - how many confidence levels available
%downsample - how many bins you want for the analysis (e.g., 6 not 10)
% requires that ratings start at 1 (no zero)

sdtR=zeros(Nratings+1,1); %Sameer adding 1 to these vectors, since 0 is now in the range of responses
sdtF=zeros(Nratings+1,1);

%get props for downsampling
for iRate=1:Nratings+1
    tmpRows=find(conf==(iRate-1));
    if ~isempty(tmpRows)
    tmpData=correct(tmpRows);
    sdtR(iRate)=sum(tmpData)/length(tmpData); %prop Remember
    sdtF(iRate)=(length(tmpData)-sum(tmpData))/length(tmpData); %prop Forgot
    end %if
end %iRate

%calculate number of trials in bins
remainder=rem(length(conf),downsample);
binSize=(length(conf)-remainder)/downsample;

%organize data
sdtData=[conf correct];%concatenate conf and correct
sdtSorted=sortrows(sdtData,1);%sort
%add sdtR and sdtF columns
for iRate=1:Nratings
    for itrial=1:length(conf) 
        sdtSorted(itrial,3)=sdtR(sdtSorted(itrial,1)+1); %SAMEER; adding 1 because index in sdtR is 1 more than actual value (index 1 == conf 0)
        sdtSorted(itrial,4)=sdtF(sdtSorted(itrial,1)+1);
    end%itrial  
end %iRate

%make frequency "table"
freqR=zeros(1,downsample);
freqF=zeros(1,downsample);

n=0;
for ibin=1:downsample
    
    if remainder==0
        
    freqR(1,ibin)=sum(sdtSorted(n+1:binSize*ibin,3));
    freqF(1,ibin)=sum(sdtSorted(n+1:binSize*ibin,4));
    n=n+binSize;
    
    elseif remainder ~=0 && ibin <= remainder

        freqR(1,ibin)=sum(sdtSorted(n+1:(binSize*ibin+ibin),3));
        freqF(1,ibin)=sum(sdtSorted(n+1:(binSize*ibin+ibin),4));
        n=n+binSize+1;
       
     elseif remainder ~=0 && ibin > remainder   
  
        freqR(1,ibin)=sum(sdtSorted(n+1:binSize*ibin+remainder,3));
        freqF(1,ibin)=sum(sdtSorted(n+1:binSize*ibin+remainder,4));
        n=n+binSize;
        
    end %if
    
end %ibin

%do cumulative proportions 
corrZero=0.5/length(conf); %SDT correction for 0
corrOne=(length(conf)-0.5)/length(conf); %SDT correction for 1

freqRC=zeros(1,downsample);
freqFC=zeros(1,downsample);

for ibin=1:downsample
    tmpFreq=nansum(freqR(ibin:downsample))/nansum(freqR);
    if tmpFreq==1 && ibin~=1
        freqRC(1,ibin)=corrOne;
    elseif tmpFreq==0
        freqRC(1,ibin)=corrZero;
    else
        freqRC(1,ibin)=tmpFreq;
    end %if
    
    tmpFreq=nansum(freqF(ibin:downsample))/nansum(freqF);
    if tmpFreq==0
        freqFC(1,ibin)=corrZero;
    elseif tmpFreq==1 && ibin~=1
        freqFC(1,ibin)=corrOne;
    else
        freqFC(1,ibin)=tmpFreq;
    end %if
end %ibin

%do zROC
zROCR=zeros(1,downsample-1);
zROCF=zeros(1,downsample-1);

for ibin=2:downsample
    zROCR(1,ibin-1)=-sqrt(2)*erfcinv(2*freqRC(1,ibin));
    zROCF(1,ibin-1)=-sqrt(2)*erfcinv(2*freqFC(1,ibin));
end %ibin

%calculate slope, intercept, da
slope=polyfit(zROCF,zROCR,1); %gives slope and intercept
da=(sqrt(2/(1+slope(1,1)^2)))*slope(1,2);
