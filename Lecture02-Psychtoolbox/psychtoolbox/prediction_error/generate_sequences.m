% Write sequences
nullpath = '/Volumes/JetDrive/workshops/Matlab/lecture2/psychtoolbox/prediction_error/optseq2';
outpath = '/Volumes/JetDrive/workshops/Matlab/lecture2/psychtoolbox/prediction_error';


% Create probability curve
prob = [0.7 0.3 0.5 0.8 0.2 0.7];
trials_in_block = [30 50 40 50 30 40];
nblock = length(trials_in_block);

% Inizialize
prob_ts = [];
block = struct();

for i=1:nblock;
    
    % number of trials within a block
    ntrials = trials_in_block(i);
    
    % load ITI-data
    if i<=3,
        fn_null = fullfile(nullpath,sprintf('null-n%d-%03d.csv',ntrials,1));
    else
        fn_null = fullfile(nullpath,sprintf('null-n%d-%03d.csv',ntrials,2));
    end
    ITI = dlmread(fn_null);
    
    % Fluctuating uncertainty across blocks
    Pr_in_block = prob(i)*ones(ntrials,1);
    prob_ts = [prob_ts; Pr_in_block];
    
    % Real / Unreal under cueT
    cueT_nReal = round(ntrials*prob(i)/2);
    cueT_nUnreal = ntrials/2 - cueT_nReal;
    seqs = [ones(cueT_nReal,1); zeros(cueT_nUnreal,1)];
    stim = cell(0);
    outcome = cell(0);
    for j=1:length(seqs),
        stim{j} = 'cueT';
        if seqs(j) == 1,
            outcome{j} = 'real';
        else
            outcome{j} = 'unreal';
        end
    end
    
    
    % Real / Unreal under cueH
    cueH_nReal = cueT_nUnreal;
    cueH_nUnreal = cueT_nReal;
    seqs = [ones(cueH_nReal,1); zeros(cueH_nUnreal,1)];
    jj = j;
    for j=1:length(seqs),
        stim{jj+j} = 'cueH';
        if seqs(j) == 1,
            outcome{jj+j} = 'real';
        else
            outcome{jj+j} = 'unreal';
        end
    end
    
    
    % Shaffling sequence using permutation
    idx = randperm(ntrials);
    outcomeOrder = cell(0);
    stimOrder = cell(0);
    for j=1:ntrials,
        stimOrder{j} = stim{idx(j)};
        outcomeOrder{j} = outcome{idx(j)};
    end
    
    
    % Shaffling order of stimulus image
    try
        imageOrder = randperm(40,ntrials);
    catch
        imageOrder1 = randperm(40);
        imageOrder2 = randperm(40,ntrials-40);
        imageOrder = [imageOrder1,imageOrder2];
    end
    
    
    block(i).prob = prob(i);
    block(i).ntrials = ntrials;
    block(i).stimOrder = stimOrder;
    block(i).outcomeOrder = outcomeOrder;
    block(i).imageOrder = imageOrder;
    block(i).ITI = ITI;
end

fn_out = fullfile(outpath,'sequence3.mat');
save(fn_out,'block');


