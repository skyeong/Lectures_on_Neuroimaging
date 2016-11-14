function generate_null(muNull,nNull,Nkeep,psdwin,outflag)
%GENERATE_NULL   a function to create random null sequence
%  muNull  : mean value for null time
%  nNull   : number of null events
%  Nkeep   : number of sequences that you want to save outputs
%  psdwin  : minimum and maximum values of null time.
%  outflag : prefix of a file name for the output. 
%
%
%  Example)
%  
%     muNull  = 2;
%     nNull   = 50;
%     Nkeep   = 3;
%     psdwin  = [0.5 6];
%     outflag = 'ex2';
%     generate_null(muNull,nNull,Nkeep,psdwin,outflag)


%--------------------------------------------------------------------------
% Parameters for random sequences
%--------------------------------------------------------------------------
N  = 20000;
if nargin<4, psdwin=[0.5, 10]; end
if nargin<5, outflag='ex1';   end


%--------------------------------------------------------------------------
% Total Estimated Time
%--------------------------------------------------------------------------
delta_precision = 0.2;


%--------------------------------------------------------------------------
% Distribution of the long-tail exponential
%--------------------------------------------------------------------------
null_dist = longtail_exp(muNull,psdwin,N);


%--------------------------------------------------------------------------
% Generating random sequences
%--------------------------------------------------------------------------
SEQ = struct();
Estimated_null_time = muNull*nNull;
cnt_perm = 1;
cnt_nseq = 1;
while 1
    
    % Randomly picking up k-trials
    shuffled_seq = randperm(N);
    ITI = zeros(nNull,1);
    for k=1:nNull,
        ITI(k) = null_dist(shuffled_seq(k));
    end
    estiamted_time = sum(ITI);
    
    % Check the total time of sequences
    if abs(estiamted_time-Estimated_null_time)<delta_precision;
        idx = randperm(length(ITI));
        ITI(idx(1)) = ITI(idx(1)) + Estimated_null_time-estiamted_time;
        
        % Put resulting sequences in SEQ
        SEQ(cnt_nseq).ITI = ITI;
        SEQ(cnt_nseq).estimated_time = estiamted_time;
        SEQ(cnt_nseq).cnt_perm = cnt_perm;
        
        cnt_nseq = cnt_nseq+1;
    end
    
    if cnt_nseq>Nkeep,
        break;
    end
    cnt_perm = cnt_perm+1;
end

OUTpath = uigetdir;
for i=1:Nkeep,
    cnt_perm = SEQ(i).cnt_perm;
    fprintf('Seq-%03d is created (estimated null time = %.1f) (nperm=%d)\n',i,estiamted_time, cnt_perm);
    
    % get null time
    nulltime = SEQ(i).ITI;
    
    % Write results
    fn_csv = sprintf('%s-%03d.csv',outflag,i);
    fn_out = fullfile(OUTpath,fn_csv);
    dlmwrite(fn_out,nulltime);
end
