function write_to_csvfile(fout,eventInfo)

% File handle
fid = fopen(fout,'w+');

% Get header information and write to file
fprintf(fid,'trial,blockid,nTrials,Pr(Real|T),stimOnset(s),stimType,predictionOnset(s),outcomeOnset(s),outcomeType,ITI(s),RT(ms),keyPressed\n');

% Write data
nTrial = length(eventInfo);
for i=1:nTrial,
    blockid      = eventInfo(i).blockid;
    prob         = eventInfo(i).prob;
    ntrials      = eventInfo(i).ntrials;
    stimOnset    = eventInfo(i).stimOnset;
    stimType     = eventInfo(i).stimType;
    prediction   = eventInfo(i).prediction;
    outcomeOnset = eventInfo(i).outcomeOnset;
    outcomeType  = eventInfo(i).outcomeType;
    ITI          = eventInfo(i).ITI;
    respTime     = eventInfo(i).respTime;
    keyPressed   = eventInfo(i).keyPressed;
    fprintf(fid,'%d, %d, %.1f, %d, %.1f, %s, %.1f, %.1f, %s, %.1f, %.1f, %s\n',i,blockid,ntrials,prob,stimOnset,stimType, prediction,outcomeOnset, outcomeType, ITI,round(respTime),keyPressed);
end

fclose(fid);