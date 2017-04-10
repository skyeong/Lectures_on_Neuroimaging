
% Examples:
%
%   1. Randomised design with 2 event-types, canonical HRF interest in both differential   and common effects

% Load Table
tablepath='/Volumes/JetDrive/workshops/Matlab/Lecture7-Efficiency/fmri_eff/woSPM/';
cnt=1;
for cnt=1:1
    
    filename=sprintf('Opt1-%04d.csv',cnt);
    T=readtable(fullfile(tablepath,filename));
    
    TR=2.5;
    
    for numcue=1:7
        C{numcue}=T.OnsetForCue(T.currCue==numcue)/TR;
    end
    for numcue=1:7
        C{numcue+7}=T.OnsetForCue_Outcome(T.currCue==numcue & T.currStimuli==1)/TR;
    end
    C{15}=T.OnsetForCue_Outcome(T.currCue==1 & T.currStimuli==0)/TR;
    C{16}=T.OnsetForCue_Outcome(T.currCue==3 & T.currStimuli==0)/TR;
    C{17}=T.OnsetForCue_Outcome(T.currCue==5 & T.currStimuli==0)/TR;
    
    S=[];
    S.sots = C;
    
    % S.Ni = 70;
    S.TR = 2;
    S.Ns = 294;          % Must be more than S.Ni*S.SOAmin/TR
    % Contrast Matrices
    % Cue1-7(CS) Cue1-7(US) Cue1,3,5(USnothing)
    S.CM{1} = [0 -1 0 0 0 1 0 zeros(1,10)];     % Cue6-Cue2(CS)
    S.CM{2} = [-1 0 0 0 0 1 0 zeros(1,10)];     % Cue6-Cue1(CS)
    S.CM{3} = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1]; % Cue1-Cue5(US,nothing)
    S.CM{4} = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0]; % Cue1-Cue3(US,nothing)
    S.CM{5} = [0 0 0 0 0 0 0 -1 0 0 0 1 0 0 0 0 0]; % Cue5-Cue1(US)
    S.CM{6} = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 -1 0 0]; % Cue3(US)-Cue1(US,nothing)
    S.CM{7} = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0]; % Cue3(US)-Cue1(US,nothing)
    
    S.HC = 120;    % high frequency cut-off
    S.bf = 'hrf';
    
    % soas = [1:20];  % to explore efficiency as function of SOA
    % S.SOAmin = soas(1);
    [e1(cnt,:),sots,stim,X,df] = fMRI_GLM_efficiency(S);  % call once to generate stimulus train
    
end



mucon = zeros(6,4);
varcon = zeros(6,4);
for j=1:6
    mucon(j,:) =[mueff1(j) mueff2(j) mueff3(j) mueff4(j)];
    varcon(j,:)=[vareff1(j) vareff2(j) vareff3(j) vareff4(j)];
end